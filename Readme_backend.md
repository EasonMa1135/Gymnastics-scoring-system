# Introduction to Gymnastics Scoring Backend

This project uses the SpringBoot framework.

## Dependency Information

* Project SDK:1.8

* Java version:8

* Springboot version:2.3.1.RELEASE

## Directory structure
```
|-- .idea
|-- .mvc
|-- include
|-- src:
|   |-- main:
        |-- java:
            |-- com.vipa.scoring.controller: Controller layer, works on the web layer, implements frontend-backend logic interfaces here
            |-- com.vipa.scoring.entity: Entity layer, used to define the attributes an entity should have, recommended to match database fields
            |-- com.vipa.scoring.mapper: Mapper layer, used to operate the database, SQL statements are implemented here
            |-- com.vipa.scoring.service: Service layer, implements methods connecting with mapper
            |-- com.vipa.scoring.utils: Utility classes, global utility classes can be placed in this package
            |-- ScoringApplication: Main class, run this file to start the project
        |-- resources: Related resources
            |-- static: Images and other static resources
            |-- templates
            |-- application.properties: Project configuration file (port, database, etc.)
|   |-- test: Tests
|-- target
|-- mvnw
|-- mvnw.cmd
|-- pom.xml: Maven dependency file
```

* Structure relationship: The mapper layer is injected into the service layer, and the service layer is injected into the controller layer.

* Suggested development order: mapper -> service -> controller


## Naming Conventions

* It is recommended that the naming of items in each package starts from the entity class. For example, if an entity `User` is defined in the entity package, the other three should be: `UserMapper`, `UserService`, `UserController`.
* Entity classes should implement setters, getters, and `toString()`.
* `Mapper` interfaces should be prefixed with the entity name. The `Service` interface should be named with the entity name + `Service`. The `Controller` class should be named with the entity name + `Controller`.

## Database Connection

To connect to the local database, modify the `application.properties` file.
 For database initialization, run the `setupDB.sql` file.

```
# MySQL username and password (for reference, configure your own)
spring.datasource.password=mysql123456
spring.datasource.username=root
# After localhost:3306/, add your database name. Here the local database name is ds
spring.datasource.url=jdbc:mysql://localhost:3306/ds?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=true
```

## Cloud Storage Service
Tencent Cloud Storage is used. For details, see the Tencent Cloud Storage documentation. You need to configure the relevant settings in `config`.
 If you don’t need cloud storage, you must manually modify the storage code, replacing cloud storage code with saving to a specified local path.

## Project Startup
Before running the project, please modify the database information to match your local database (once the overall database design is complete, you can connect to a remote database, see Yuque documentation for details). Run the `ScoringApplication.java` file to start the project. The console will output as follows:

<img width="1318" alt="截屏2023-03-19 19 50 29" src="https://user-images.githubusercontent.com/65934928/226173388-906e491d-78ea-4bd2-b760-d15906b72392.png">

In the browser, enter: `localhost:8080/hello`

<img width="1257" alt="截屏2023-03-19 19 53 41" src="https://user-images.githubusercontent.com/65934928/226173416-1dae9050-1928-4ad6-8dbc-bd837d25d86d.png">

The project started successfully!
## Debugging Suggestions
You can use Postman software for debugging.
For more, see: https://blog.csdn.net/m0_61843874/article/details/123324727

