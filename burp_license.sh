#!/bin/bash
#author: Mrxn
#home: https://github.com/Mr-xn/burpsuite_pro_for_mac

burp_path='/Applications/Burp Suite Professional.app/Contents/Resources/app'
BurpLoaderKeygen='BurpLoaderKeygen.jar'
burp_vmoptions='/Applications/Burp Suite Professional.app/Contents'
vmoptions='user.vmoptions'
java_bin='/Applications/Burp Suite Professional.app/Contents/Resources/jre.bundle/Contents/Home/bin/java'


#vmoptions
cat << EOF > "$vmoptions"
--add-opens=java.base/java.lang=ALL-UNNAMED
--add-opens=java.base/java.lang=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED
-javaagent:BurpLoaderKeygen.jar
-noverify
EOF

#check and download BurpLoaderKeygen.jar
download() {
    local url="$1"
    local file="$2"
    wget -c -t 3 -U 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36' --no-check-certificate -O "$file" "$url"
}
check_dependencies() {
    if ! ping -q -c 1 -W 1 bing.com >/dev/null; then
        echo "[!] No internet connection. Please check your internet connection."
        exit
    elif ! command -v wget &> /dev/null; then
        if ! command -v brew &> /dev/null; then
            echo 'Please install brew first.'
            echo 'see https://docs.brew.sh/Installation'
            exit
        fi
        echo "wget is not installed. "
        echo 'use brew install wget now ...'
        brew install wget
    fi
}
if [ ! -e "$BurpLoaderKeygen" ]; then
    echo "BurpLoaderKeygen.jar not exists"
    check_dependencies
    #download BurpLoaderKeygen
    echo 'Starting Downlaod BurpLoaderKeygen'
    download 'https://mrxn.net/content/uploadfile/202308/3ef21691155956.jar' "$BurpLoaderKeygen"
    if [ ! -e "$BurpLoaderKeygen" ]; then
        echo "Download failed. Retrying with default URL ..."
        download 'https://cdn.mrxn.net?url=https%3A%2F%2Fmrxn.net%2Fcontent%2Fuploadfile%2F202308%2F3ef21691155956.jar' "$BurpLoaderKeygen"
        if [ ! -e "$BurpLoaderKeygen" ]; then
            echo "Download failed. Please try again later or download the file manually."
            exit
        fi
    fi
fi

#check path
if [ -d "$burp_path" ]; then
#copy resource
echo "copy $BurpLoaderKeygen to burp_path: 
$burp_path"
cp "$BurpLoaderKeygen" "$burp_path"

#copy vmoptions
echo "copy $vmoptions to burp_path: 
$burp_vmoptions"
cp "$vmoptions" "$burp_vmoptions"

#start BurpLoaderKeygen
echo 'start BurpLoaderKeygen'
"$java_bin" -jar "$burp_path"/"$BurpLoaderKeygen" -a -i 1 -n "$USER"
else
    echo 'Directory does not exist'
    echo 'only for dmg install burp! exit now.'
    exit
fi
