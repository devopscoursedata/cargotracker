pipeline {
    agent  any
    tools {
        
         maven 'maven'
}
            
    environment { 
NEXUS_VERSION = "nexus3" 
NEXUS_PROTOCOL = "http" 
NEXUS_URL = "3.110.108.136:8081/" 
NEXUS_REPOSITORY = "maven-nexus-repo" 
NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
}
    
     stages {
        
         stage("Maven Build") {
           steps {
                script {
                    sh "mvn clean package -DskipTests=true"
                }
            }
        }
        stage("SonarQube analysis") {
            steps {
              withSonarQubeEnv('sonarqube') {
                sh 'mvn sonar:sonar'
            
              }
            }
          }
          stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
            
            }
            stage ("ansible"){
           steps {
             sh "ansible-playbook playbook.yaml"
   
          
       }}   

     }
     }
