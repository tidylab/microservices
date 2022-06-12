# Reference:
# <https://stackoverflow.com/questions/63317771/launch-docker-automatically-when-starting-ec2-server>

# 1. Create docker_boot.service


# 2. Copy docker_boot.service to systemd
system("sudo cd ~")
system("sudo cp -v ./microservices/docker_boot.service /etc/systemd/system")


# 3. Enable and start docker_boot.service
system("sudo docker-compose down")
# system("sudo systemctl unmask docker")
system("sudo systemctl enable docker")
system("sudo systemctl start docker")

# system("sudo systemctl unmask docker_boot.service")
system("sudo systemctl enable docker_boot.service")
system("sudo systemctl start docker_boot.service")


# 4. Check status of the docker_boot.service
system("sudo systemctl status docker_boot.service")


# 5. Check if the microservice is up
system("sudo curl -L localhost:8080/__docs__/")
