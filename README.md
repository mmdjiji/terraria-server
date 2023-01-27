# Terraria Server

![terraria logo](assets/terraria-logo.png)

The docker image for Terraria Server. Always pull the latest version of server automatically, so the only thing you can do is to run the following command on your server with Docker installation.

## Usage

```sh
sudo docker run -itd \
  --name=terraria-server \
  -v terraria:/opt/terraria \
  -p 7777:7777 \
  mmdjiji/terraria-server:latest
```

## Configuration
Change the configuration file: `/opt/terraria/serverconfig.txt`

```
maxplayers=200
password=terraria
```

The default password is `terraria`, you can change this field to your password.

## License

[GPL-3.0](LICENSE)