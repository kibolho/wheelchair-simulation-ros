# Wheelchair

Simulação de Cadeira de Rodas Autônoma - TCC Curso de Engenharia Elétrica - IFES 2020

Select the model:
export TURTLEBOT3_MODEL=wheelchair //[burger, waffle, waffle_pi, wheelchair]

Command to display the model in rviz:
roslaunch turtlebot3_description display.launch

Command to display the model in gazebo:
roslaunch turtlebot3_description gazebo.launch

Command to control the robot:
rostopic pub -1 /cmd_vel geometry_msgs/Twist -- '[0.1, 0.0, 0.0]' '[0.0, 0.0, 0.0]'
roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch

Command open the house map with the robot:
roslaunch turtlebot3_gazebo turtlebot3_house.launch

Command to run slam:
roslaunch turtlebot3_slam turtlebot3_slam.launch slam_methods:=gmapping

[![Watch the video](https://i.imgur.com/tlLSt38.png)](https://www.youtube.com/watch?v=MN8X7QZI1YM&t=1s&ab_channel=Ab%C3%ADlioMarcos)

