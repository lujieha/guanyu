@echo off
chcp 65001 >nul
title Git 推送工具
color 0A

:: 设置颜色函数
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "RESET=[0m"

echo ========================================
echo    Git 提交并推送工具 v2.0
echo ========================================
echo.

:: 检查 Git 仓库
if not exist ".git" (
    echo %RED%[错误]%RESET% 当前目录不是 Git 仓库！
    echo 请在项目根目录运行此脚本
    pause
    exit /b 1
)

:: 检查是否有更改
git diff --quiet && git diff --cached --quiet
if errorlevel 1 (
    echo %GREEN%[信息]%RESET% 检测到文件更改
) else (
    echo %YELLOW%[提示]%RESET% 没有检测到更改
    echo.
    choice /C YN /M "是否仍然提交并推送"
    if errorlevel 2 exit /b 0
)

:: 显示当前分支
for /f %%i in ('git branch --show-current') do set "current_branch=%%i"
echo %GREEN%当前分支:%RESET% %current_branch%
echo.

:: 显示将要提交的文件
echo %GREEN%将提交以下文件:%RESET%
git status --short
echo.

:: 获取提交信息
set /p commit_msg="请输入提交信息 (默认: 更新项目): "
if "%commit_msg%"=="" set commit_msg=更新项目 - %date% %time%

:: 添加所有更改
echo.
echo %GREEN%[1/4]%RESET% 添加所有更改...
git add . 2>nul

:: 提交
echo %GREEN%[2/4]%RESET% 提交代码...
git commit -m "%commit_msg%" >nul 2>&1

if errorlevel 1 (
    echo %YELLOW%[提示]%RESET% 没有需要提交的更改
) else (
    echo %GREEN%[成功]%RESET% 提交完成
)

:: 拉取远程更新（避免冲突）
echo %GREEN%[3/4]%RESET% 拉取远程更新...
git pull --rebase >nul 2>&1

if errorlevel 1 (
    echo %YELLOW%[警告]%RESET% 拉取失败，将直接推送
)

:: 推送到远程
echo %GREEN%[4/4]%RESET% 推送到 GitHub...
git push

if errorlevel 1 (
    echo.
    echo %RED%[错误]%RESET% 推送失败！
    echo 可能原因：
    echo 1. 网络连接问题
    echo 2. 需要先 pull 远程更改
    echo 3. GitHub 认证失败
    echo.
    echo 尝试强制推送？(不推荐)
    choice /C YN /M "是否强制推送"
    if errorlevel 2 goto :end
    git push --force
) else (
    echo.
    echo %GREEN%========================================%RESET%
    echo %GREEN%   ✓ 成功推送到 GitHub！%RESET%
    echo %GREEN%========================================%RESET%
)

:end
echo.
echo 按任意键退出...
pause >nul