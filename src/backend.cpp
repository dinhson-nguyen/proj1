#include "include/backend.h"
#include <iostream>
#include <sstream>
#include "include/json.hpp"
#include <string>
#include <regex>
#include <std_stamped_msgs/EmptyStamped.h>
#include <cstdio>
#include <fstream>
#include <string>
#include <unistd.h>

using json = nlohmann::json;
Backend::Backend(QObject* parent)
    : QObject(parent), nh()
{
    // Initialize the subscriber in the constructor
    battery_percent_sub = nh.subscribe("/arduino_driver/float_param/battery_percent", 1, &Backend::batteryPercentCallback, this);
    battery_voltage_sub = nh.subscribe("/arduino_driver/float_param/battery_voltage", 1, &Backend::batteryVoltageCallback, this);
    battery_current_sub = nh.subscribe("/arduino_driver/float_param/battery_ampe", 1, &Backend::batteryCurrentCallback, this);
    robot_mode_sub = nh.subscribe("/robot_mode", 1, &Backend::robotModeCallback, this);
    robot_status_sub = nh.subscribe("/robot_status", 1, &Backend::robotStatusCallback, this);
    fastech_input_sub = nh.subscribe("/fastech_input", 1, &Backend::fastechInputCallBack, this);
    fastech_output_sub = nh.subscribe("/fastech_output", 1, &Backend::fastechOutputCallBack, this);
    velocity_sub = nh.subscribe("/final_cmd_vel_mux/output", 1, &Backend::cmdVelCallBack, this);


    request_run_stop_pub = nh.advertise<std_stamped_msgs::StringStamped>("/request_run_stop", 1);
    reset_error_pub = nh.advertise<std_stamped_msgs::EmptyStamped>("/reset_error", 1);
    robot_mode_pub = nh.advertise<std_stamped_msgs::StringStamped>("/request_mode", 1);
    robot_control_pub = nh.advertise<std_stamped_msgs::StringStamped>("/request_working_stt", 1);

    bug_manual_mode = true;
    index = 0;
    QTranslator* translator = new QTranslator();
    m_translator.load(QStringLiteral(":/simplequick.qm"));
    qApp->installTranslator(&m_translator);
    qApp->removeTranslator(&m_translator);


    std::string name = "";
    try {
        YAML::Node config = YAML::LoadFile("/home/mkac/robot_config/robot_define.yaml");

        // The outer element is an array
        if (config["agv_name"] && config["agv_name"].IsScalar()) {
            std::string name = config["agv_name"].as<std::string>();
            std::string ip_server = config["server_address"].as<std::string>();
            server_address = QString::fromStdString(ip_server);

            agv_name = QString::fromStdString(name);
        }

    }
    catch (const YAML::BadFile& e) {
        ROS_ERROR("Cannot get AGV name");
    }
    catch (const YAML::ParserException& e) {
        ROS_ERROR("Cannot get AGV name");
    }
    std::string result = exec("pactl set-sink-mute @DEFAULT_SINK@ true");
}

std::vector<std::string> Backend::splitString(std::string str, char delimiter) {
    std::vector<std::string> result;
    std::stringstream ss(str);
    std::string item;

    while (std::getline(ss, item, delimiter)) {
        result.push_back(item);
    }

    return result;
}


void Backend::batteryPercentCallback(const std_stamped_msgs::Float32Stamped& msg) {
    batteryPercentageStr = double(msg.data);
    if (batteryPercentageStr >= 99) batteryPercentageStr = 100;
    emit batteryPercentageChanged();

}

void Backend::batteryVoltageCallback(const std_stamped_msgs::Float32Stamped& msg) {
    batteryVoltageStr = double(msg.data);
    emit batteryVoltageChanged();

}

void Backend::batteryCurrentCallback(const std_stamped_msgs::Float32Stamped& msg) {
    batteryCurrentStr = double(msg.data);
    emit batteryCurrentChanged();

}

void Backend::robotModeCallback(const std_stamped_msgs::StringStamped::ConstPtr& msg) {
    // robot_mode = std::string(msg ->data);
    robotModeStr = QString::fromStdString(msg->data);
    emit robotModeChanged();
}

void Backend::robotStatusCallback(const std_stamped_msgs::StringStamped::ConstPtr& msg) {

    std::string data = msg->data;
    try
    {
        json jsondata = json::parse(data);
        statusValue = jsondata["status"];
        detailValue = jsondata["detail"];
        robot_mode = jsondata["mode"];
        errorValue = jsondata["error_code"];
    }
    catch (...)
    {
        ROS_INFO("Loi chuyen doi json callback /robot_status");
    }


    if (statusValue == "PAUSED") {
        getControlStr = QString::fromStdString(statusValue);
        emit getControlChanged();
    }
    else if (statusValue == "RUNNING")
    {
        getControlStr = QString::fromStdString(statusValue);
        statusValue = "NORMAL";
        emit getControlChanged();
    }
    else if (statusValue == "WAITING")
    {
        getControlStr = QString::fromStdString("RUNNING");
        emit getControlChanged();
    }

    if (robot_mode == "AUTO") {
        bug_manual_mode = true;
    }

    else ROS_INFO_STREAM(robot_mode);
    robotStatusStr = QString::fromStdString(statusValue);
    emit robotStatusChanged();


    robotDetailStr = QString::fromStdString(detailValue);
    // ROS_INFO_STREAM(robot_mode);
    emit robotDetailChanged();


    robotErrorStr = QString::fromStdString(errorValue);
    emit robotErrorChanged();

    // robotModeStr = QString::fromStdString(modeValue);
    // emit robotModeChanged();

}

void Backend::fastechInputCallBack(const std_msgs::Int16MultiArray::ConstPtr& msg) {
    std::vector<int16_t> data_ = msg->data;
    fastechData.clear();
    fastechData.reserve(data_.size());
    for (int i = 0; i < data_.size();i++) {
        fastechData.push_back(static_cast<int>(data_[i]));
    }
    emit getFastechInputChanged();

}

void Backend::fastechOutputCallBack(const std_msgs::Int16MultiArray::ConstPtr& msg) {
    // fastechDataOutput.clear();
    // fastechDataOutput.reserve(msg->data.size());
    // for (int value : msg->data) {
    //     fastechDataOutput.push_back(static_cast<int>(value));
    // }
    std::vector<int16_t> data_ = msg->data;
    fastechDataOutput.clear();
    fastechDataOutput.reserve(data_.size());
    for (int i = 0; i < data_.size();i++) {
        fastechDataOutput.push_back(static_cast<int>(data_[i]));
    }

    emit getFastechOutputChanged();

}

void Backend::cmdVelCallBack(const geometry_msgs::Twist& msg) {
    vel_linear = double(msg.linear.x);
    vel_angular = double(msg.angular.z);

    emit velChanged();

}


int Backend::getFastechRear(int index) {
    return fastechData[int(index) - 1];
}

int Backend::getFastechFront(int index) {
    return fastechDataOutput[int(index) - 1];
}

double Backend::batteryPercentage() const {
    return batteryPercentageStr;
}

double Backend::batteryVoltage() const {
    return batteryVoltageStr;
}

double Backend::batteryCurrent() const {
    return batteryCurrentStr;
}

QString Backend::robotMode() const {
    return robotModeStr;
}

QString Backend::robotStatus() const {
    return robotStatusStr;
}

QString Backend::robotDetail() const {
    if (bug_manual_mode == 0) {
        return QString::fromStdString("Please change AGV mode to AUTO");
    }
    return robotDetailStr;
}

QString Backend::robotError() const {
    return robotErrorStr;
}

QString Backend::getControl() const {
    return getControlStr;
}

QString Backend::getNameAGV() {
    return agv_name;
}

double Backend::getLinear() const {
    return vel_linear;
}

double Backend::getAngular() const {
    return vel_angular;
}


void Backend::resetError() {
    std_stamped_msgs::EmptyStamped msg;
    if (robotModeStr.toStdString() == "AUTO") {

        reset_error_pub.publish(msg);

    }
    else {
        bug_manual_mode = false;
        ROS_INFO_STREAM(robotModeStr.toStdString());
    }
}


void Backend::requestMode(const QString& str) {

    std_stamped_msgs::StringStamped request_mode_msg;
    request_mode_msg.stamp = ros::Time::now();
    request_mode_msg.data = str.toStdString();
    robot_mode_pub.publish(request_mode_msg);
}


void Backend::requestControl(const QString& str) {

    std_stamped_msgs::StringStamped request_control_msg;
    request_control_msg.stamp = ros::Time::now();
    if (robotModeStr.toStdString() == "AUTO") {

        if (str.toStdString() == "STOP") {
            request_control_msg.data = "STOP";
            request_run_stop_pub.publish(request_control_msg);
        }
        else {
            request_control_msg.data = "RUN";
            request_run_stop_pub.publish(request_control_msg);
        }

    }
    else {
        bug_manual_mode = false;
        ROS_INFO_STREAM(robotModeStr.toStdString());
    }

}

int Backend::getVolume() {
    std::string result = exec("amixer -D pulse sget Master");

    int volumePercentage = getVolumePercentage(result);

    return volumePercentage;
}

int Backend::setVolume(int percent) {
    std::string command = "amixer -D pulse sset Master " + std::to_string(percent) + "%";
    system(command.c_str());
    return percent;
}

void Backend::shutdown(int state) {
    if (state == 1) {
        std::string command = " ";
    }
}

void Backend::getVolume_on_off(int i) {
    if (i == 0) {
        std::string result = exec("pactl set-sink-mute @DEFAULT_SINK@ true");
    }
    else std::string result = exec("pactl set-sink-mute @DEFAULT_SINK@ false");
    // std::string result = exec("amixer -D pulse sset Master toggle");

    // int i = getVolumePercentage(result);

}

void Backend::change_to_japan() {

    // qApp ->installTranslator(&m_translator);

}

void Backend::change_to_eng() {
    qApp->removeTranslator(&m_translator);
}

QString Backend::getIP() {
    std::string ip = " ";
    FILE* pipe = popen("ip -4 addr show dev enp3s0", "r");
    if (!pipe) {
        return QString::fromStdString(ip);
    }

    char buffer[128];
    std::string result = "";
    while (fgets(buffer, sizeof(buffer), pipe) != nullptr) {
        result += buffer;
    }

    // Close the pipe
    pclose(pipe);

    // Use regular expression to find the IP address
    std::regex ipRegex(R"((\d{1,3}\.){3}\d{1,3})");
    std::smatch ipMatch;
    if (std::regex_search(result, ipMatch, ipRegex)) {
        return QString::fromStdString(ipMatch.str());
    }
    return QString::fromStdString(ip);
}


QString Backend::getIPServer() {
    return server_address;
}


