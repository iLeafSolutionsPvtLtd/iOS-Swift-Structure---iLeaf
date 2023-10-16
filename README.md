# iOS-Swift-Structure---iLeaf
# MVVM-C (Combine+UIKit)

A Sample app to view the list of some of the weather data based on your current location. 
It also includes a view to add your "To do" tasks.

Weather data

   * fetch and display the current location details.
   * shows current temperature,wind speed, wind and direction of current location.

To Do

   * Add a new task and store in local storage.
   * List the tasks and mark completed ones.
    
 We are using a free weather API for getting the weather data . https://api.open-meteo.com/v1/forecast?current_weather=true&latitude={latitude}&longitude={longitude} 
To test this API we need to replace the latitude and longitude with any valid location coordinates. 
  
# Architecture

This project is POC for MVVM-C pattern. where:

   * View is represented by UIViewController designed in Storyboard
   * Model represents state and domain objects
   * ViewModel interacts with Model and prepares data to be displayed.
   * Coordinator is responsible for handling application flow, decides when and where to go      based on events from ViewModel. 
   * Network repository is for making the API calls and handle the responses. There will be separate repository protocols for each view models.
   
We are using combine frame work and protocols for real time updates.


![mvvmc](https://github.com/iLeafSolutionsPvtLtd/iOS-Swift-Structure---iLeaf/assets/75235228/f15f0467-0453-4d97-bca0-53aef9cd905a)


# Code coverage report
To see the code coverage report, open the Report Navigator on the left, select the report for the last test run, and open the Coverage tab at the top. swift is completely covered by the unit tests we wrote.

<img width="1478" alt="codeCoverageReport" src="https://github.com/iLeafSolutionsPvtLtd/iOS-Swift-Structure---iLeaf/assets/75235228/246f84a2-d427-4891-8cab-ded76b179b3c">


# Installation
  * Installation by cloning the repository
  * Go to directory
  * use command + B or Product -> Build to build the project
  * Choose a device and press run icon in Xcode or command + R to run the project on Simulator
# Running The Tests Manually
  * Go to Product-> Test to run all tests.
  * In the Project Navigator under Test Navigator tab, check test status
  * In the Project Navigator under report Navigator check for coverage undet test


