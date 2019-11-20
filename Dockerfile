FROM ubuntu

MAINTAINER "krzysztof.stezala@student.put.poznan.pl"
LABEL version="1.0"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install xfce4 -y
RUN apt-get install xfce4-goodies -y
RUN apt-get purge -y pm-utils xscreensaver*
RUN apt-get install wget -y
RUN apt-get install -y terminator firefox net-tools

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update
RUN apt-get install ros-melodic-desktop-full -y
RUN rosdep init
RUN rosdep update 

# Creating ROS_WS
RUN mkdir -p ~/ros_ws/src

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
                  cd ~/ros_ws/ && rm -rf build devel && \
                  catkin_make"

RUN /bin/bash -c "echo 'source ~/ros_ws/devel/setup.bash' >> /root/.bashrc"

# VNC part
EXPOSE 5901

RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
RUN mkdir ~/.vnc
RUN echo "123456" | vncpasswd -f >> ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd


CMD ["/usr/bin/vncserver", "-fg"]