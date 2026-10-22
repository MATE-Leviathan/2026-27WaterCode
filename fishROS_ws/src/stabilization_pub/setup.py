from setuptools import find_packages, setup

package_name = 'stabilization_pub'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='NCCSMUnderwaterRobotics',
    maintainer_email='ncssmunderwaterrobotics@gmail.com',
    description='Depth-hold and stabilization control package.',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': ['stabilization_pub = stabilization_pub.stabilization_pub:main'],
    },
)
