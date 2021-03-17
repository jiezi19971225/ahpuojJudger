# AHPUOJ JUDGER

OJ 的判题环境镜像，其中 judge_client 修改自 HUSTOJ 的判题程序。

## 调试开发判题机
构建完镜像后 进入容器内手动运行 judge_client 进行调试
```sh
# 入参 第二个参数 ojhome 第三个参数 问题id 第四个参数 语言 第五个参数 时间限制 第六个参数内存限制 第七个参数 runid
# 如果参数超过7个，开启DEBUG模式，打印调试信息
./judge_client /home/judge/hustoj_core 4 1 1 128 0 DEBUG
```

## 构建镜像

```sh
docker build . -t ahpuoj-judger
```
