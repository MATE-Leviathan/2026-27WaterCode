from setuptools import setup

package_name = 'bar02_pub'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='NCCSMUnderwaterRobotics',
    maintainer_email='ncssmunderwaterrobotics@gmail.com',
    description='Blue Robotics Bar02 pressure/depth and temperature sensor',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': ['bar02_pub = bar02_pub.bar02_pub:main'],
    },
)
