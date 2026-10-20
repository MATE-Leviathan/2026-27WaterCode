#!/usr/bin/env

"""
Date Created: 04/27/2024
Author(s): Everett Tucker
Description: Publishes orientation data from an Adafruit BNO055 IMU
Subscribers: None
Publishers: IMU
"""

import rclpy
import busio
import time
import math
import adafruit_bno055
import tf_transformations
from rclpy.node import Node
from sensor_msgs.msg import Imu
from geometry_msgs.msg import Quaternion
from std_msgs.msg import Int32

from board import SCL, SDA

BAUD_RATE = 115200

class IMUPub(Node):
    def __init__(self):
        #IMU
        super().__init__("imu_publisher")
        # There are some special arguments that go in this function
        self.i2c = busio.I2C(SCL, SDA)
        self.sensor = adafruit_bno055.BNO055_I2C(self.i2c, address=0x28)
        # Creating the IMU Publisher
        self.imu_publisher = self.create_publisher(Imu, 'imu', 10)
        #Temperature
        self.temp_publisher = self.create_publisher(Int32, 'InternalTempData', 10)
        #timer
        timer_period = 0.02
        self.timer = self.create_timer(timer_period, self.publish_sensor_data)

    
    def publish_sensor_data(self):
        euler = self.sensor.euler
        temperature = self.sensor.temperature

        if euler is None:
            self.get_logger().error("Failed reading IMU Euler orientation data")
            return

        if temperature is None:
            self.get_logger().error("Failed reading IMU temperature data")
            return

        # BNO055 Euler values are degrees.
        # quaternion_from_euler expects radians.
        roll = math.radians(euler[0])
        pitch = math.radians(euler[1])
        yaw = math.radians(euler[2])

        q = tf_transformations.quaternion_from_euler(roll, pitch, yaw)

        # Publish IMU data.
        imu_msg = Imu()
        imu_msg.orientation = Quaternion(x=q[0], y=q[1], z=q[2], w=q[3])
        self.imu_publisher.publish(imu_msg)

        # Publish temperature data.
        # Int32 requires an integer.
        temp_msg = Int32()
        temp_msg.data = int(round(temperature))

        self.temp_publisher.publish(temp_msg)


def main(args=None):
    rclpy.init(args=args)
    node = IMUPub()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
