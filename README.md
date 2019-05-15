# wait-services
The script waiting for services to be started in docker-compose containers and accessible by host:port

## Usage
```bash
$ WAIT_ATTEMPTS=2 WAIT_SERVICES=google.com:80,google.com:81 wait-services
Service google.com:80 is ready
Service google.com:81 is not ready
Service google.com:81 is not ready

```

### An example for docker-compose
```yaml
version: '2'
services:
  first_service:
    image: alpine
    command: sh -c "sleep 5; nc -lk -p 11111 0.0.0.0"

  second_service:
    image: alpine
    command: sh -c "sleep 8; nc -lk -p 22222 0.0.0.0"

  app:
    build: .
    environment:
      - WAIT_SERVICES=first_service:11111,second_service:22222
      - WAIT_ATTEMPTS=10
    depends_on:
      - first_service
      - second_service
    command: sh -c "wait-services && nc -z first_service 11111 && echo Connected"
```
Run the services:

```bash
$ docker-compose up
Starting waitservices_first_service_1 ... 
Starting waitservices_second_service_1 ... 
Starting waitservices_first_service_1
Starting waitservices_second_service_1 ... done
Recreating waitservices_app_1 ... 
Recreating waitservices_app_1 ... done
Attaching to waitservices_first_service_1, waitservices_second_service_1, waitservices_app_1
app_1             | bash: connect: Connection refused
app_1             | bash: /dev/tcp/first_service/11111: Connection refused
app_1             | Service first_service:11111 is not ready
app_1             | bash: connect: Connection refused
app_1             | bash: /dev/tcp/first_service/11111: Connection refused
app_1             | Service first_service:11111 is not ready
app_1             | Service first_service:11111 is ready
app_1             | bash: connect: Connection refused
app_1             | bash: /dev/tcp/second_service/22222: Connection refused
app_1             | Service second_service:22222 is not ready
app_1             | bash: connect: Connection refused
app_1             | bash: /dev/tcp/second_service/22222: Connection refused
app_1             | Service second_service:22222 is not ready
app_1             | bash: connect: Connection refused
app_1             | bash: /dev/tcp/second_service/22222: Connection refused
app_1             | Service second_service:22222 is not ready
app_1             | Service second_service:22222 is ready
app_1             | All services have started successfully
app_1             | Connected
waitservices_app_1 exited with code 0
^CGracefully stopping... (press Ctrl+C again to force)
Stopping waitservices_second_service_1 ... done
Stopping waitservices_first_service_1  ... done
```

## Options
- **WAIT_SERVICES**: List of services for waiting (host:port).
- **WAIT_ATTEMPTS**: Max number of attempts to check services availability (default 30).
- **WAIT_BEFORE**: Number of second to wait before start checking (default 0). 
- **WAIT_SLEEP**: Number of second between checks (default 1).
- **WAIT_AFTER**: Number of second to wait after checking is finished (default 0). 

## Notes
Some ideas has been taken from
* https://github.com/ufoscout/docker-compose-wait
* https://github.com/dadarek/docker-wait-for-dependencies
 