require 'nokogiri'
require_relative 'configuration'

module AutodeployBootstrap 
      
  class DeploymentPlan
    include AutodeployBootstrap
 
    def initialize(hostname, environment)
      @hostname = hostname
      @environment = environment
    end

    def to_xml
      a_host = AutodeployBootstrap::Host.first(:name => @hostname)
      raise StandardError, "No host found in autodeploy database with name '#{@hostname}'" if a_host.nil?
      a_environment = AutodeployBootstrap::Environment.first(:name => @environment)
      $LOGGER.debug "Deployment Plan Environment: #{a_environment}"
      raise StandardError, "No environment found in autodeploy database with name '#{@environment}'" if a_environment.nil?
      a_repo = a_environment.repo
      a_property_assembler = a_environment.property_assembler
      a_host_class = AutodeployBootstrap::HostClass.get(a_host.host_class_id)
      a_applications = AutodeployBootstrap::HostClassApplication.all(:host_class => a_host_class).collect { |hca| hca.application }
      a_platform = AutodeployBootstrap::Platform.first
      
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.plan(:id => 12345) {
          xml.platform(:name => a_platform)
          xml.host(:name => a_host, :id => a_host.id, :hostclass => a_host_class, :environment => a_environment) {
            xml.repository {
              xml.url(:url => a_repo.base_url)
              xml.type(:type => a_repo.type)
            }
            xml.propertyAssembler {
              xml.url(:url => a_property_assembler.config_assembler_url)
            }
            xml.forceDeploy true
            # APPLICATIONS
            a_applications.each do |app|
              xml.application(:name => app.name, :id => app.id) {
                xml.type app.type
                xml.pillar app.pillar
                xml.marketPlace app.market_place
                xml.balancerType app.balancer_type
                xml.startStopScript app.start_stop_script
                xml.context_ app.context
                xml.downloadName app.download_name
                xml.artifactId app.artifact_id
                xml.groupId app.group_id
                xml.suffix app.suffix
                xml.verificationJMXBean app.verificationjmxbean
                xml.verificationJMXAttribute app.verificationjmxattribute
                xml.releaseInfoJMXBean app.release_infojmxbean
                xml.releaseInfoJMXAttribute app.release_infojmxattribute
                xml.release "git"
                xml.revision "LATEST"
                xml.install_path app.install_dir
                xml.symlink app.symlink
                xml.properties_path app.properties_path
                xml.start_on_deploy app.start_on_deploy
                xml.assemble_properties app.assemble_properties
                xml.doProbe app.do_probe
                xml.probeAuthMethod app.probe_auth_method
                xml.probeBasicAuthUser app.probe_auth_user
                xml.probeBasicAuthPassword app.probe_auth_password
                xml.probeAuthUser
                xml.probeAuthPassword
                xml.modulename
                xml.testUrls {                  
                  app.test_urls.split(',').each do |t|               
                    xml.testUrl t
                  end
                }
              }
            end
          }
        }
      end
      
      builder.to_xml
      
    end
    
    def save 
      File.open(File.expand_path("deploy.xml", CONFIG[:temp_dir]), 'w') { |file| file.write(self.to_xml) }
    end
    
    def path
      CONFIG[:temp_dir] + '/deploy.xml'
    end

  end
end

=begin
  <plan id='93833'>
    <platform name='mobile' />
    <host name='search47-1' id='537' hostclass='SEARCH' environment='Production'>
      <repository>
        <url url='http://maven-download.mobile.rz/maven/hosted-mobile-deployment-productive-releases' />
        <type type='ARCHIVA' />
      </repository>
      <propertyAssembler>
        <url url='http://maven.corp.mobile.de/config-assembler' />
      </propertyAssembler>
      <forceDeploy>false</forceDeploy>
      <application name='mobile-public-search-germany-webapp.war' id='81'>
        <type>TANUKI_TOMCAT</type>
        <pillar>DE-OEB-SEARCH</pillar>
        <marketPlace>GERMANY</marketPlace>
        <balancerType>MODJK</balancerType>
        <startStopScript />
        <context>/fahrzeuge</context>
        <downloadName>mobile-public-search-germany-webapp-%REV%.war</downloadName>
        <artifactId>mobile-public-search-germany-webapp</artifactId>
        <groupId>de.mobile</groupId>
        <suffix>war</suffix>
        <verificationJMXBean />
        <verificationJMXAttribute />
        <releaseInfoJMXBean></releaseInfoJMXBean>
        <releaseInfoJMXAttribute></releaseInfoJMXAttribute>
        <release>git</release>
        <revision>        2991.jdk7.master.db60232</revision>
        <install_path />
        <symlink />
        <properties_path />
        <start_on_deploy>true</start_on_deploy>
        <assemble_properties>true</assemble_properties>
        <instance_properties>true</instance_properties>
        <doProbe>true</doProbe>
        <probeAuthMethod>none</probeAuthMethod>
        <probeBasicAuthUser></probeBasicAuthUser>
        <probeBasicAuthPassword></probeBasicAuthPassword>
        <probeAuthUser />
        <probeAuthPassword />
        <modulename>mobile-public-search-germany-webapp</modulename>
        <testUrls>
          <testUrl>%CONTEXT%/release-info</testUrl>
        </testUrls>
      </application>
    </host>
  </plan>
  
=end