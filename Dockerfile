FROM ubuntu:latest

USER root
RUN apt update
RUN apt install curl unzip screen -y

EXPOSE 7777

RUN mkdir /opt/terraria/
ADD terraria/ /opt/terraria/

RUN chmod 775 /opt/terraria/terraria.sh 

CMD ["./opt/terraria/terraria.sh", "start"]