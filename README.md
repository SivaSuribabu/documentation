# Ansible documentation

# how to install ansible in ec2
-- sudo apt update
-- sudo apt upgrade -y
-- sudo apt install -y software-properties-common
-- sudo add-apt-repository --yes --update ppa:ansible/ansible
-- sudo apt install ansible -y
-- ansible --version

# how to create ssh keys
-- ssh-keygen -t rsa

# how to copy ssh keys to target ec2
-- ssh-copy-id ubuntu@1.1.1.1
-- we can manually copy to the target ec2

# where the ansible files are located
-- /etc/ansible/hosts
-- sudo nanoo hosts
-- [webservers]
  -- 1.1.1.1
  -- 2.2.2.2
-- [dbservers]
  -- 3.3.3.3
  -- 4.4.4.4

# how to ping all servers at a time
-- ansible all -m ping 
-- ansbile -m ping webservers
-- ansible -m ping dbservers

# how to copy a file into target servers
-- ansible all -m copy -a "src=/home/ubuntu/test.txt dest=/home/ubuntu/test.txt" --become

# how to remove a file from targer servers
-- ansible all -m file -a "path=/home/ubuntu/test.txt state=absent" --become


