from setuptools import find_packages, setup

package_name = 'thruster_driver'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='NCSSMUnderwaterRobotics',
    maintainer_email='ncssmunderwaterrobotics@gmail.com',
    description='Drives the thrusters from twist messages over serial to the Pico',
    license='Apache-2.0',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
            # TODO Figure out what goes here
        ],
    },
)
