# bridge-tech-talk-thibautr

This repository is used to share all resources used during bridge tech talk.
It will never be updated after.

## First deploy infrastructure ECS

You will need almost 1h to deploy it.
Use folder infra with AWS_PROFILE=padok_lab to be fully compatible.
I do it quick and dirty so some values/id need to be harcoded when resources has been created.
You will need to update at least route53 layer to use you own domaine name.

[Infra deployement](./infra/README.md)

## Start debug

I choose ECS to do this demo but it could done with EKS too.

### List ECS tasks
```zsh
export AWS_PROFILE=padok_lab
aws ecs describe-tasks --region eu-west-3 --cluster btt-production-cluster --tasks $(aws ecs list-tasks  --region eu-west-3 --cluster btt-production-cluster --query 'taskArns[*]' --no-paginate | jq '.[]' --raw-output | tr '\n' ' ') --query 'tasks[*].containers[*].{TaskArn: taskArn, ContainerName: name, Status: lastStatus, PrivateIP: networkInterfaces[0].privateIpv4Address} | sort_by(@, &[0].ContainerName) ' --output table
```

### Check the connectivity from the bastion
```zsh
TASK_IP=10.4.0.9
TASK_ARN="arn:aws:ecs:eu-west-3:207567786373:task/btt-production-cluster/d84c0e944ca344fbb8cc4603a5509e29"
nc -vz $TASK_IP
```

### Open a port-foward on server

```zsh
INSTANCE_ID=i-08033b4872e888316
aws ssm start-session --region eu-west-3 --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"host\":[\"$TASK_IP\"],\"portNumber\":[\"3000\"], \"localPortNumber\":[\"3000\"]}"
```

### start the debuger mode

- Get terminal access to the ECS task:

```zsh
TASK_ARN="arn:aws:ecs:eu-west-3:207567786373:task/btt-production-cluster/d84c0e944ca344fbb8cc4603a5509e29"
aws ecs execute-command --cluster btt-production-cluster --task $TASK_ARN --interactive --command sh
```

- Send SIGUSR1 signal to node server to enable debugger:

```sh
apt-get update && apt-get install net-tools
kill -USR1 1
```

Check if the debuger is started
```zsh
netstat -tuln
```

### Open port-forward on debugger

- Start both port-forwarding in 2 terminals (be sure to have export AWS_PROFILE, AWS_REGION first or add option in these commands):

```zsh
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"host\":[\"$TASK_IP\"],\"portNumber\":[\"9229\"], \"localPortNumber\":[\"9229\"]}"
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"host\":[\"$TASK_IP\"],\"portNumber\":[\"3000\"], \"localPortNumber\":[\"3000\"]}"
```

- Expected result :

```sh
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.1:9229          0.0.0.0:*               LISTEN
tcp        0      0 :::3000                 :::*                    LISTEN
```

### Create a new task revision with the debug port

- The task definition most important are those parameters: `--inspect-port=0.0.0.0:9229` and `portMappings` values:

```json

            "command": ["node", "--inspect-port=0.0.0.0:9229", "dist/apps/api-gateway/main.js"],
            "portMappings": [
                {
                    "name": "target",
                    "containerPort": 3000,
                    "hostPort": 3000,
                    "protocol": "tcp"
                },
                {
                    "name": "debug",
                    "containerPort": 9229,
                    "hostPort": 9229,
                    "protocol": "tcp"
                }
            ],
```

### Vscode onfiguration

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Docker: Attach to Node",
            "type": "node",
            "request": "attach",
            "port": 9229,
            "address": "127.0.0.1",
            "localRoot": "${workspaceFolder}/node_app/00-app",
            "remoteRoot": "/usr/src/app",
            "protocol": "inspector"
        }
    ]
}
```

### Now you are ready to do ECS remote debug

Enjoy it, hope this training will help you !
