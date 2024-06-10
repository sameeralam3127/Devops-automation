To create a Java project, set it up for testing with Jenkins, and save all the code on GitHub, follow these steps:

### Step 1: Set Up the Java Project

1. **Install Java Development Kit (JDK)**:
   Make sure you have JDK installed on your system. You can download it from [Oracle's website](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).

2. **Create a new Java project**:
   Use an IDE like IntelliJ IDEA, Eclipse, or create the project manually.

   Here's a simple structure for a Maven project:

   ```
   MyJavaProject
   ├── src
   │   └── main
   │       └── java
   │           └── com
   │               └── example
   │                   └── App.java
   ├── pom.xml
   └── README.md
   ```

3. **pom.xml**:
   Create a `pom.xml` file for Maven dependencies.

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <groupId>com.example</groupId>
       <artifactId>MyJavaProject</artifactId>
       <version>1.0-SNAPSHOT</version>
       <properties>
           <maven.compiler.source>11</maven.compiler.source>
           <maven.compiler.target>11</maven.compiler.target>
       </properties>
       <dependencies>
           <!-- JUnit 5 dependency for testing -->
           <dependency>
               <groupId>org.junit.jupiter</groupId>
               <artifactId>junit-jupiter-engine</artifactId>
               <version>5.7.0</version>
               <scope>test</scope>
           </dependency>
       </dependencies>
       <build>
           <plugins>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-surefire-plugin</artifactId>
                   <version>2.22.2</version>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

4. **App.java**:
   Create a simple Java application.

   ```java
   package com.example;

   public class App {
       public static void main(String[] args) {
           System.out.println("Hello, World!");
       }
   }
   ```

5. **Unit Test**:
   Create a test for the application.

   ```java
   package com.example;

   import org.junit.jupiter.api.Test;
   import static org.junit.jupiter.api.Assertions.assertEquals;

   public class AppTest {
       @Test
       public void testApp() {
           assertEquals(1, 1); // Simple test
       }
   }
   ```

### Step 2: Set Up Jenkins

1. **Install Jenkins**:
   Download and install Jenkins from the [official website](https://www.jenkins.io/).

2. **Configure Jenkins**:
   - Create a new Jenkins job (Freestyle or Pipeline).
   - Set up the SCM to use Git and provide the GitHub repository URL.

3. **Jenkins Pipeline Script** (if using a Pipeline job):
   ```groovy
   pipeline {
       agent any
       tools {
           maven 'Maven 3.6.3' // Adjust based on your Maven installation
           jdk 'JDK 11' // Adjust based on your JDK installation
       }
       stages {
           stage('Checkout') {
               steps {
                   git 'https://github.com/yourusername/MyJavaProject.git'
               }
           }
           stage('Build') {
               steps {
                   sh 'mvn clean package'
               }
           }
           stage('Test') {
               steps {
                   sh 'mvn test'
               }
           }
       }
   }
   ```

### Step 3: Save the Code on GitHub

1. **Create a new repository on GitHub**:
   - Go to [GitHub](https://github.com/) and create a new repository.

2. **Push the code to GitHub**:
   ```bash
   cd MyJavaProject
   git init
   git remote add origin https://github.com/yourusername/MyJavaProject.git
   git add .
   git commit -m "Initial commit"
   git push -u origin master
   ```

### Summary

1. Set up a Maven-based Java project.
2. Write a simple Java application and a unit test.
3. Install and configure Jenkins to build and test the project.
4. Create a repository on GitHub and push your code to it.

Once these steps are complete, you should have a Java project in GitHub that Jenkins can pull, build, and test.
