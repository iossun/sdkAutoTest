#! /bin/bash
#
# Program
#       该脚本用于自动运行单元测试，并且生成 HTML 报告
#
#

# 获取根目录
CURRENT_DIR="../sdkAutoTest.xcodeproj";
TARGET_TEST="sdkAutoTest";

if [ -d "$CURRENT_DIR" ];
    then
    # 如果文件存在，则进行字符串分割
    declare CURRENT_LAST_FILELEN=`echo "$CURRENT_DIR" | awk -F ''\/'' '{printf "%d",length($NF)}'`
    declare CURRENT_POS=$[ ${#CURRENT_DIR} - $CURRENT_LAST_FILELEN  ];
    # 获取文件名称
    declare ProjName=${CURRENT_DIR:$CURRENT_POS:$CURRENT_LAST_FILELEN};
    CURRENT_PATH=${CURRENT_DIR:0:$CURRENT_POS};
#        echo $CURRENT_PATH;

    #CURRENT_PATH=${CURRENT_PATH//\/shells/""};

    # shell脚本执行环境
    SHEEL_CURRENT_PATH=$(cd `dirname $0`; pwd);
    SHELL_PATH="$SHEEL_CURRENT_PATH";

    # 最终生成报告的目录
    ROOT_DIR="${CURRENT_PATH}test-reports";

    # 单元测试报告目录文件目标地址
    LOG_DESTINATION_DIR="${ROOT_DIR}/reports.js"

    # 需要测试的工作空间 xcworkspace
    WORKSPACE_DIR=$CURRENT_DIR

    # 工作空间模式，project OR workspace
    WORKSPACE_TYPE="workspace";
    if [[ $ProjName =~ xcworkspace ]]
    then
        WORKSPACE_TYPE="workspace";
    else
        WORKSPACE_TYPE="project";
    fi

    # 代码覆盖率文件名称
    TestCoverageFileName="coverage.js"

    # 代码测试结果文件夹名称，系统参数，切勿修改
    UnitTestFileName="sys-reports"

    # 测试环境
    EnvTestToSimulator="platform=iOS Simulator,name=iPhone 8"

    # 删除旧报告文件内容
    if [ -d "$ROOT_DIR" ];
        then
         rm -rf "$ROOT_DIR"
    fi

    # 创建目录文件
    mkdir "$ROOT_DIR"
    echo "报告目录创建成功"

    ##### --------xc2json.sh---- BEGIN 利用系统命令生成报告 ----------------- #######

 echo "------------- ${ROOT_DIR}------------${WORKSPACE_TYPE}-------------${TARGET_TEST}"

    # 生成单元测试报告,并且将日志文件吸入 reports.log 文件
    # xcodebuild -enableCodeCoverage YES test -project ../sdkAutoTest.xcodeproj -scheme sdkAutoTest -destination "platform=iOS Simulator,name=iPhone 8"  -resultBundlePath "../test-reports" -resultBundleVersion 3
    # echo `xcodebuild -enableCodeCoverage YES test -$WORKSPACE_TYPE ../sdkAutoTest.xcodeproj -scheme $TARGET_TEST -destination "platform=iOS Simulator,name=iPhone 8" -resultBundlePath "$ROOT_DIR/$UnitTestFileName"` > "$ROOT_DIR/reports.log";
    xcodebuild -enableCodeCoverage YES test -${WORKSPACE_TYPE} ../sdkAutoTest.xcodeproj -scheme ${TARGET_TEST} -destination "platform=iOS Simulator,name=iPhone 8"  -resultBundlePath "$ROOT_DIR/$UnitTestFileName" -resultBundleVersion 3
    ##### ------------ END 利用系统命令生成报告 ----------------- #######
   
   ruby ./UnitTestParser/unitTestInfo.rb --xcresult-path=$ROOT_DIR/$UnitTestFileName.xcresult --output-file=result.txt
   xcrun xccov view --report --json $ROOT_DIR/$UnitTestFileName.xcresult > ./result.json
   ruby ./UnitTestParser/targetCoverage.rb --cov-json-path=result.json --output-file=targetCoverageResult.html

   rm -rf ./result.json
   rm -rf ./tmpCov.txt

else
    echo "$1 is not exist!";
fi