![](README_assets/banner.png)
# Ready App for Travel & Transporation

## Overview

IBM Ready App for Travel & Transportation delivers a seamless travel experience by guiding the user through the transitional stages of travel. Customer engagement is maximized by providing a best in class travel management system offering personalized and contextual information at the right time. 

The T&T Ready App accentuates the entire journey by:

* Proactively reacting to travel changes in real time.
* Subtly offering deals targeting customers’ personality and context.
* Providing deep customer insight into the rail traveler’s journey.
* Showcasing rail travel as the central hub of a travel management system integrating internal and external data sources.

## Getting Started

Please visit the [Getting Started page](http://lexdcy040194.ecloud.edst.ibm.com/travel_1_0_0/getting_started) to set up the project.

## Documentation

Please visit [this page](http://lexdcy040194.ecloud.edst.ibm.com/travel_1_0_0/home) for access to the full documentation.

## Project Structure

* `/iOS` directory for the iOS client.

* `/liberty` WebSphere Liberty project that contains the main backend JAX-RS project. 

* `/travel-businessrules` contains the rules and rule flows to apply discounts to partnering hotel bookings.

* `/travel-businessrules-app` contains the associated application built by Business Rules. The application is deployed in the cloud to execute the rules on BlueMix.

* `/travel-businessrules-deployment`  contains the target locations of Business Rules services (i.e. the url and credentials of our Business Rules service on BlueMix).

* `/travel-java-common` Common Java code shared between the Business Rules and JAX-RS code.

* `/Travel-mfpf` Mobile First Platform Foundation project containing the iOS native project and java script adapters.  Used as a common backend sitting between the JAX-RS service and the front end client(s).    



## License

IBM Ready App for Travel & Transportation is available under the IBM Ready Apps License Agreement. See the [License file](https://github.com/IBM-MIL/IBM-Ready-App-for-Travel/blob/master/License.txt) for more details.