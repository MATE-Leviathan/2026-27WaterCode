from setuptools import setup

package_name = 'ph_pub'

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
    description='pH sensor publisher package.',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': ['ph_pub = ph_pub.ph_pub:main'],
    },
)
