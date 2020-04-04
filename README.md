# AHPUOJ JUDGER

OJ 的判题环境镜像，其中 judge_client 修改自 HUSTOJ 的判题程序。

## 打包镜像

docker build ahpuojJudger -t ccr.ccs.tencentyun.com/jiezi19971225/ahpuoj-judger:1.1.1

## 编译 scheduler

powershell 下

```sh
$env:CGO_ENABLED=0
$env:GOOS="linux"
$env:GOARCH="amd64"
go build scheduler.go
```

## 编译 judge_client

windows环境下，可以创建一个 ubuntu 18.04 的容器用于编译操作。

