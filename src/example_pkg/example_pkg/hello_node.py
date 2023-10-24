from contextlib import suppress

import rclpy
from rclpy.node import Node

from std_msgs.msg import Empty, Int32


class HelloNode(Node):
    def __init__(self):
        super().__init__('hello_node')
        self.pub_counter = self.create_publisher(Int32, 'counter', 10)
        self.timer = self.create_timer(1, self.timer_callback)
        self.i = 0

        self.sub_ping = self.create_subscription(Empty, 'ping', self.ping_callback, 10)
        self.pub_pong = self.create_publisher(Empty, 'pong', 10)

    def timer_callback(self):
        self.pub_counter.publish(Int32(data=self.i))
        self.i += 1

    def ping_callback(self, _: Empty):
        self.pub_pong.publish(Empty())


def main(args=None):
    rclpy.init(args=args)
    hello = HelloNode()
    with suppress(KeyboardInterrupt):
        rclpy.spin(hello)


if __name__ == '__main__':
    main()
