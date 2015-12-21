#Builds Ubuntu Apache2 image

#FROM mrlesmithjr/ansible:ubuntu-12.04
#FROM mrlesmithjr/ansible:ubuntu-14.04
FROM mrlesmithjr/ansible

MAINTAINER mrlesmithjr@gmail.com

#Installs git
RUN apt-get update && apt-get install -y \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Clean up Ansible playbooks
RUN rm -rf /opt/ansible-playbooks

#Clone docker ansible playbooks from GitHub
RUN git clone https://github.com/mrlesmithjr/docker-ansible-playbooks.git /opt/ansible-playbooks/

#Install Ansible role requirements
RUN ansible-galaxy install -r /opt/ansible-playbooks/apache2/requirements.yml

#Run Ansible playbook to install Apache2
RUN ansible-playbook -i "localhost," -c local /opt/ansible-playbooks/apache2/playbook.yml

#Remove Ansible roles
RUN ansible-galaxy remove /etc/ansible/roles/*

#Clean up Ansible Playbooks
RUN rm -rf /opt/ansible-playbooks

#Clean up APT
RUN apt-get clean

#Expose 80/tcp
EXPOSE 80

ENTRYPOINT ["apache2ctl"]

CMD ["-D", "FOREGROUND"]
