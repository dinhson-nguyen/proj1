#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <ros/ros.h>
#include <std_stamped_msgs/Float32Stamped.h>
#include <std_stamped_msgs/StringStamped.h>
#include <std_stamped_msgs/EmptyStamped.h>
#include <string>
#include <iostream>
#include "json.hpp"
#include <fstream> 
#include <cmath> 
#include <std_msgs/Int16MultiArray.h>
#include <vector>
#include <geometry_msgs/Twist.h>
#include <sstream>
#include <cstdio>
#include <memory>
#include <QTranslator>
#include <yaml-cpp/yaml.h>
#include <cstdlib>
// #include <QApplication>
#include <QGuiApplication>

using json = nlohmann::json;
class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double batteryPercentage READ batteryPercentage NOTIFY batteryPercentageChanged)
    Q_PROPERTY(double batteryVoltage READ batteryVoltage NOTIFY batteryVoltageChanged)
    Q_PROPERTY(double batteryCurrent READ batteryCurrent NOTIFY batteryCurrentChanged)
    Q_PROPERTY(QString robotStatus READ robotStatus NOTIFY robotStatusChanged)
    Q_PROPERTY(QString robotDetail READ robotDetail NOTIFY robotDetailChanged)
    Q_PROPERTY(QString robotError READ robotError NOTIFY robotErrorChanged)
    Q_PROPERTY(QString getControl READ getControl NOTIFY getControlChanged)
    Q_PROPERTY(QString robotMode READ robotMode NOTIFY robotModeChanged)
    Q_PROPERTY(double getLinear READ getLinear NOTIFY velChanged)
    Q_PROPERTY(double getAngular READ getAngular NOTIFY velChanged)
private:
    ros::NodeHandle nh;
    ros::Subscriber battery_percent_sub;
    ros::Subscriber battery_voltage_sub;
    ros::Subscriber battery_current_sub;
    ros::Subscriber robot_mode_sub;
    ros::Subscriber robot_status_sub;
    ros::Subscriber standard_io_sub;
    ros::Subscriber fastech_input_sub;
    ros::Subscriber fastech_output_sub;
    ros::Subscriber velocity_sub;
    // ros::Subscriber run_pause_sub;

    
    ros::Publisher robot_mode_pub;
    ros::Publisher request_run_stop_pub;
    ros::Publisher request_working_stt_pub;
    ros::Publisher reset_error_pub;
    ros::Publisher robot_control_pub;


    // QString formatJsonString(const QString& rawJson);
    // json toJson(const char* jsonString);
    std::vector<std::string> splitString(std::string str, char delimiter);

    void batteryPercentCallback(const std_stamped_msgs::Float32Stamped &msg);
    void batteryVoltageCallback(const std_stamped_msgs::Float32Stamped &msg);
    void batteryCurrentCallback(const std_stamped_msgs::Float32Stamped &msg);
    void robotModeCallback(const std_stamped_msgs::StringStamped::ConstPtr &msg);
    
    void robotStatusCallback(const std_stamped_msgs::StringStamped::ConstPtr &msg);
    void fastechInputCallBack(const std_msgs::Int16MultiArray::ConstPtr &msg);
    void fastechOutputCallBack(const std_msgs::Int16MultiArray::ConstPtr &msg);
    void cmdVelCallBack(const geometry_msgs::Twist &msg);
    // void standardIoCallback(const std_stamped_msgs::StringStamped &msg);


    double batteryVoltageStr;
    double batteryPercentageStr;
    double batteryCurrentStr;
    QString robotModeStr;
    QString qRosHostname;
    QString robotStatusStr;
    QString robotDetailStr;
    QString robotErrorStr;
    QString getControlStr;
    QString agv_name;
    QString server_address;

    std::vector<int> fastechData;
    std::vector<int> fastechDataOutput;

    std::string statusValue;
    std::string robot_mode;
    std::string detailValue;
    std::string errorValue;
    bool bug_manual_mode;
    int index;


    double start_time = ros::Time::now().toSec();
    double interval = 1.0; // Thời gian mong muốn giữa mỗi lần kiểm tra
    double cpu_return ;

    double vel_linear;
    double vel_angular;

    
    unsigned long long prevIdle, prevTotal;

    std::string exec(const char* cmd) {
        std::array<char, 128> buffer;
        std::string result;
        std::shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
        if (!pipe) throw std::runtime_error("popen() failed!");
        while (!feof(pipe.get())) {
            if (fgets(buffer.data(), 128, pipe.get()) != nullptr)
                result += buffer.data();
        }
        return result;
    }

    int getVolumePercentage(const std::string& mixerOutput) {
        std::istringstream ss(mixerOutput);
        std::string line;
        while (std::getline(ss, line)) {
            size_t pos = line.find("[");
            if (pos != std::string::npos && line.find("%]") != std::string::npos) {
                std::string percentage = line.substr(pos + 1, line.find("%") - pos - 1);
                // ROS_INFO_STREAM(std::stoi(percentage));
                return std::stoi(percentage);
            }
        }
        return -1; // return -1 if not found
    }

public:
    explicit Backend(QObject *parent = nullptr);
    QTranslator m_translator;


    // SUBCRIBER
    double batteryPercentage() const;
    double batteryVoltage() const;
    double batteryCurrent() const;
    QString robotMode() const;
    QString robotStatus() const;
    
    QString robotDetail() const;
    QString robotError() const;

    QString getControl() const;

   
    
    double getLinear() const;
    double getAngular() const;
    // int getFastechRear(int index) const;




    // PUBLISHER
    Q_INVOKABLE  int getFastechRear(int index);
    Q_INVOKABLE  int getFastechFront(int index);
    Q_INVOKABLE void resetError() ;
    Q_INVOKABLE void requestMode(const QString &str) ;
    Q_INVOKABLE void requestControl(const QString &str) ;
    Q_INVOKABLE  int setVolume(int percent) ;
    Q_INVOKABLE  int getVolume() ;
    Q_INVOKABLE  void shutdown(int state);
    Q_INVOKABLE void getVolume_on_off(int i);

    Q_INVOKABLE  void change_to_japan() ;
    Q_INVOKABLE  void change_to_eng() ;
    Q_INVOKABLE  QString getNameAGV() ;
    Q_INVOKABLE  QString getIP() ;
    Q_INVOKABLE  QString getIPServer() ;


signals:
    void batteryPercentageChanged();
    void batteryVoltageChanged();
    void batteryCurrentChanged();
    void robotModeChanged();
    void robotStatusChanged();
    void robotDetailChanged();
    void robotErrorChanged();
    void getNameChanged();
    void getIPChanged();
    void getControlChanged();
    void getFastechInputChanged();
    void getFastechOutputChanged();
    void velChanged();
    void volumePercentageChanged();


};

#endif // BACKEND_H
