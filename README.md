# terraria-server

The docker image for Terraria Server.

## Usage

```sh
sudo docker run -itd \
  --name=terraria-server \
  -v terraria:/opt/terraria \
  -p 7777:7777 \
  mmdjiji/terraria-server:lastest
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