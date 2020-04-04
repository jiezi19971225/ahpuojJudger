# AHPUOJ JUDGER

OJ 的判题环境镜像，包含了基于 HUSTOJ 判题程序改造的 judge_client 和调度程序。

## 打包镜像

docker build ahpuojJudger -t ccr.ccs.tencentyun.com/jiezi19971225/ahpuoj-judger:1.1.1

## 编译 scheduler

必须设置编译选项 CGO_ENABLED=0

powershell 下

```sh
$env:CGO_ENABLED=0
$env:GOOS="linux"
$env:GOARCH="amd64"
go build scheduler.go
```

## 编译 judge_client

创建一个 alpine 容器，在其中进行编译。

