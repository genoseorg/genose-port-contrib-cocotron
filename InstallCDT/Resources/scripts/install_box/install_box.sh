#!/bin/sh

# ########## # ########### ########### ########### ##########
# ##
# ##    Created by Genose.org (Sebastien Ray. Cotillard)
# ##    Date 10-oct-2016
# ##    last update 10-nov-2016
# ##
# ##    Please support genose.org, the author and his projects
# ##    
# ##    Based on genose.org tools
# ##
# ##    //////////////////////////////////////////////////////////////
# ##    // http://project2306.genose.org  // git :: project2306_ide //
# ##    /////////////////////////////////////////////////////////////
# ##
# ########## # ########### ########### ########### ##########
InstalledSoftware_path_GUI_dialog=${InstalledSoftware_path_GUI_dialog-$(which xdialog)}
PWD=${PWD-$(pwd)}

echo ":::: DIALOG :: ${InstalledSoftware_path_GUI_dialog}"

# ################## # ##################
# ################## # ##################
_script=$( echo "$PWD/$0" | sed -e "s;${PWD};;g"  | sed -e "s;\.\/;;g" ) 
_script="$PWD/$0"
_script=$( echo "$_script" | sed -e "s;\.\/;;g" )

PWD=$( find $( dirname $_script | xargs dirname ) -name common_functions.sh -type f | xargs dirname )
_script=$( find $PWD -name "install_box.sh" -type f   ) 
 
# ## echo " script $PWD :: "$_script
# ################## # ##################
# ################## # ##################
 
install_box_dir=$( echo $_script | xargs dirname )
# ## echo " :::install_box_dir:: "$install_box_dir
# ################## # ##################
# ################## # ##################

source $(  find $(dirname $install_box_dir | xargs dirname  ) -name common_functions.sh -type f -print )

# ################## # ##################
# ################## # ##################

cat > /tmp/install_box.tmp <<EOF
#!/bin/bash

"${InstalledSoftware_path_GUI_dialog}" 	--title "Target style for Target ${productCrossPorting_Target} ?" \
        --ok-label "Continue with SDK STYLE Path "  \
        --cancel-label "Not Interrested (default  path)" \
        --yesno " Would you like to pack all Installation in platform/SDK style ? \
        \n This will move files to somethink like \n\
 \n \
 \n SDKROOT = \
 \n  -  ${SDK_STYLE_PATH} \
 \n    \
 \n - {SDKROOT}/${productCrossPorting_Target}.sdk/usr/include \
 \n - {SDKROOT}/${productCrossPorting_Target}.sdk/bin/GCC \
 \n - {SDKROOT}/${productCrossPorting_Target}.sdk/usr/include \
 \n - {SDKROOT}/${productCrossPorting_Target}.sdk/Frameworks \
 \n
" 0 0 
EOF
 
# ################## # ##################
# ################## # ##################

dailog_result_SDK=$( sh /tmp/install_box.tmp 2>&1  && echo $?  && echo "cc"   ||    echo $? && echo "vv"    )

 switch_case_SDK=$( echo ${dailog_result_SDK} | awk '{print $1}' )
echo "SDK_STYLE :: ${dailog_result}  :: "$?"::"$switch_case_SDK

# ## void value

let "switch_case_SDK= switch_case_SDK+0"

echo "SDK_STYLE :: as int ::"$switch_case_SDK
case  $switch_case_SDK in
    0)
      echo "Yes chosen. SDK"
      SDK_STYLE="SDK"
    ;;
    1)
        echo "No chosen. SDK"
        SDK_STYLE=""
    ;;
    *)
    echo "Box close chosen. SDK"
     "${InstalledSoftware_path_GUI_dialog}"  --timeout 5 	--title "Information "    --msgbox "Installation Cancelled ...  "  20 80
     int_user
     ;;
esac

# ################## # ##################
# ################## # ##################

# ## targetList=$( basename $( ls -d Resources/scripts/install_box/archs/* | tr "\ " "\\n" )  )
targetListDesc=$( find $install_box_dir -name "desc.txt" -type f    | grep -i "target" | grep -vi "compiler" | grep -vi "ide" | sort )
 
echo "" > /tmp/install_box_desc.tmp
chmod 755 /tmp/install_box_desc.tmp

echo "" > /tmp/install_box.tmp
chmod 755 /tmp/install_box.tmp
 
 
# ## find $install_box_dir -name 'target' | tee | while IFS= read -r filename; do cat "compiler/$filename"; done

cat > /tmp/install_box.tmp <<EOF 
#!/bin/bash

"${InstalledSoftware_path_GUI_dialog}" --title "Installation from ${SYSTEM_HOST}" xxzzxx\
    --check "Build only for 64Bits (if avail)" "on"  \
        --ok-label "This is the target and compiler"  \
        --cancel-label "Cancel installation" \
    --treeview "Choose Target System and Compiler " 32 120 0 \
    "all:default" "Install All Targetable Systems Supported with Default Parameters for all Target" off 0  xxzzxx
EOF
 
 
for descfile in ${targetListDesc[@]} ; do
    source $descfile
    
    system_desc=$( echo ${descfile} | xargs dirname | xargs dirname | xargs basename  )
    compiler_desc_dir=$( echo ${descfile} | xargs dirname )
     echo "desccompiler find :: ${system_desc} :: $compiler_desc_dir "
    compilerDescDir=$( find $compiler_desc_dir -name "desc.txt" -type f    | grep -i "compiler" | sort )
    
    echo  $system_desc "...." ${system_install_desc}
    # ## system :: target :: compiler :: compiler_path ;;so all def are reloaded from the desc file config
    echo ${system_install_desc}    | sed -e "s;\(.*$\);\"x${SYSTEM_HOST}\_${system_desc}:default:default\" \"From ${SYSTEM_HOST} \-\-\\ \>\> to ${SDK_STYLE} : \1\" off 0 xxzzxx;g" >> /tmp/install_box.tmp
     
        for desccompiler in ${compilerDescDir[@]} ; do
            compiler_choose="default"
            source $desccompiler
            desccompiler=$( echo ${desccompiler} | sed -e "s;"${install_box_dir}";;g" )
            echo "desccompiler :: ${system_desc} :: $desccompiler :: ${compiler_choose}"
            echo ${system_install_desc}    | sed -e "s;\(.*$\);\"x${SYSTEM_HOST}\_${system_desc}:${compiler_choose}:${desccompiler}\" \"Install Cross Compiler : ${compiler_desc} ( ${compiler_version} - ${compiler_date} )\" off 1 xxzzxx;g" >> /tmp/install_box.tmp
        done
done

 
echo \"x_latest:default\"  \""Latest Default target Avail / Compatible with my System \(${SYSTEM_HOST}\)"\"  off 0   >>   /tmp/install_box.tmp
# ################## # ##################
# ################## # ##################
  dailog_result=$(  cat  /tmp/install_box.tmp |  sed -e "s;xxzzxx;=;g" | tr "=" "\\"  | sh   && echo $? || echo $? )
# ## dailog_result=$( bash /tmp/install_box.tmp 2>&1  && echo $? || echo $? )
echo ":::dailog_result:::${dailog_result}"
switch_case=$( echo ${dailog_result} | tr "xx_" "\\n"  |  tail -n1 | awk '{if(length($2)){ if(length($3)){print $3}else{ print $2} }else{print $1}}' )
do_longbits_switch_case=$( echo ${dailog_result} | tr "xx_" "\\n"  |  tail -n1 | awk '{if(length($2)){ print $2 }else{print $1}}' )
 
if [ "${do_longbits_switch_case}" == "checked" ]; then
    productCrossPorting_Target_arch_wordSize="64"
    productCrossPorting_Target_arche="x86_64"
else
    productCrossPorting_Target_arch_wordSize="32"
    productCrossPorting_Target_arch="i386"
fi

echo " :::switch_case: ${switch_case} "
case  $switch_case in
  0)
    echo "Yes chosen.";;
  
  *)
    echo "Box closed. system "
    
     "${InstalledSoftware_path_GUI_dialog}"  --timeout 5 	--title "Information "    --msgbox "Installation Cancelled ...  "  20 80 
    int_user
    ;;
esac



platform_choose=$( echo $dailog_result | tr "_" "\ " | tr ":" "\ " | awk '{ print $2 }' )

system_choose=$( echo $dailog_result | tr "_" "\ " | tr ":" "\ " | awk '{ print $1 }' )

echo "::platform_choose:dailog_result:" $dailog_result  "::platform_choose::" $platform_choose

case $platform_choose in
    default)
        platform_choose=$( echo ${productCrossPorting_Target_default}  | tr "[:upper:]" "[:lower:]" )
        ;;
    latest)
        platform_choose=$( echo "${productCrossPorting_Target_default}-${platform_choose}"  | tr "[:upper:]" "[:lower:]" )
        ;;
    *) ;;
esac

echo "::::" $dailog_result  "::platform_choose::" $platform_choose


compiler_choose_host=$( echo $dailog_result | tr ":" "\ " | awk '{ print $2 }' )

compiler_choose_file=$( echo $dailog_result | tr ":" "\ " | awk '{ print $3 }' )
compiler_choose_file=${compiler_choose_file-""}

echo "::compiler_choose_target::" $compiler_choose_target  " :: " $compiler_choose_file

case $compiler_choose_host in
    default)
    # ## set to GCC or default from config
        compiler_choose_host=$( echo ${productCrossPorting_Host_default_compiler}  | tr "[:upper:]" "[:lower:]" )
        # compiler_choose_target=$( echo ${productCrossPorting_Target_default_compiler}  | tr "[:upper:]" "[:lower:]" )
        ;;
    latest)
        compiler_choose_host=$( echo ${productCrossPorting_Host_default_compiler}  | tr "[:upper:]" "[:lower:]" )
       #  compiler_choose_target=$( echo ${productCrossPorting_Target_default_compiler}  | tr "[:upper:]" "[:lower:]" )
        productCrossPorting_Host_default_compiler_getLatest="--yes--"
        productCrossPorting_Target_default_compiler_getLatest="--yes--"
        ;;
    *)
    
        if [ ! -f "${install_box_dir}/${compiler_choose_file}" ]; then
            exit_witherror "${install_box_dir}/${compiler_choose_file}" $_script $LINENO
        else
            source "${install_box_dir}/${compiler_choose_file}"
            compiler_choose_host=${compiler_choose-${compiler_choose_host}}
            compiler_choose_host_version="${compiler_version}"
            compiler_choose_host_version_date="${compiler_date}"
          fi
        source $( find "${install_box_dir}/archs/${platform_choose}/target/compiler" -iname "conf.inc" -print | head -n1 )
        
        # ## i386-unknown-${target}darwin$osVersion
        compiler_choose_target="${productCrossPorting_Target_compiler}"
         
        compiler_choose_target_version=""
        compiler_choose_target_version_date=""
        compiler_choose_target_configure="${productCrossPorting_Target_compiler_ConfigureFlags}"

    ;;
esac
 echo "::compiler_choose_target:final:" $compiler_choose_target  " :: " $compiler_choose_file

# ################## # ##################
# ################## # ##################         
productCrossPorting_Target="${platform_choose}"




echo "SDK_STYLE :: ${dailog_result_SDK}  :: "$?"::"$switch_case_SDK
case  $switch_case_SDK in
  0)
    echo "Yes chosen."
    SDK_STYLE="SDK"
    SDK_STYLE_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/${productCrossPorting_Target}.platform/Developer/SDKs/${productCrossPorting_Target}${productCrossPorting_Target_default_version}.sdk/"
    echo "Should Create : ${SDK_STYLE_PATH} "
    echo "${SDK_STYLE_PATH}/System/Library/CoreServices"
    echo "${SDK_STYLE_PATH}/System/Library/Frameworks"
    echo "${SDK_STYLE_PATH}/System/Library/Printers"
    echo "${SDK_STYLE_PATH}/System/Library/PrivateFrameworks"
    
    echo "${SDK_STYLE_PATH}/usr"
    
    echo "${SDK_STYLE_PATH}/usr/bin"
    echo "${SDK_STYLE_PATH}/usr/include"
    echo "${SDK_STYLE_PATH}/usr/lib"
    echo "${SDK_STYLE_PATH}/usr/libexec"
    echo "${SDK_STYLE_PATH}/usr/share"
    
    echo "${SDK_STYLE_PATH}/SDKSettings.plist"
    echo " ====== ======== SEtting ===== ======== "
    
    SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec=$( find  $(dirname $install_box_dir | xargs dirname  ) -iname "SDKSettings.plist" -print )
    plist_set="--no--"
    
    cat "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}" > "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}.${productCrossPorting_Target}"
    
    function plist_settarget()
    {
        plist_set_spec="${1}"
        plist_set_spec_file="${2-${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}}"
        
        
        plist_set_spec_skip=${3-$(echo 0 )}
        let "plist_set_spec_skip= plist_set_spec_skip+1"
        let "plist_set_spec_skip= plist_set_spec_skip-1"
        
        plist_set=$( /usr/libexec/PlistBuddy  -c "Print :${plist_set_spec}" "${plist_set_spec_file}"  )
         
        plist_set=$(  eval 'echo "'${plist_set}'"' | xargs echo )
        
        if [ ${plist_set_spec_skip} -eq 0 ]; then
            /usr/libexec/PlistBuddy  -c "Set :${plist_set_spec} ${plist_set}"  "${plist_set_spec_file}.${productCrossPorting_Target}"
        fi
        
    }
    
    plist_settarget "DisplayName"  "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    echo "SDK  Display name : ${plist_set}"
    
    plist_settarget 'CanonicalName'                                     "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"   
    echo "SDK  CanonicalName : ${plist_set}"
    
    plist_settarget 'MinimalDisplayName'                                "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    echo "SDK  MinimalDisplayName :  ${plist_set} "

    plist_settarget 'Version'                                           "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    echo "SDK  Version (package min MacOS version): ${plist_set} "
    
    plist_settarget 'DefaultProperties:MACOSX_DEPLOYMENT_TARGET'         "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    echo "SDK  DefaultProperties:MACOSX_DEPLOYMENT_TARGET: ${plist_set} "
    
    plist_settarget 'DefaultProperties:PLATFORM_NAME'                    "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    echo "SDK  DefaultProperties:PLATFORM_NAME : ${plist_set} "
    
    # ## plist_settarget 'DefaultProperties:DEFAULT_KEXT_INSTALL_PATH'        "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    # ## echo "SDK DefaultProperties:DEFAULT_KEXT_INSTALL_PATH : ${plist_set} "
    
    plist_settarget 'SupportedBuildToolComponents'                       "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}" 1
    echo "SDK  SupportedBuildToolComponents : ${plist_set} "
    
    plist_settarget 'MaximumDeploymentTarget'                            "${SYSTEM_HOST_IDEGUI_TARGET_SDK_plist_spec}"
    echo "SDK  MaximumDeploymentTarget: ${plist_set} "
    
    echo " ====== ========  ===== ======== "
    ;;
  1)
    echo "No chosen.";;
  *)
    echo "Box closed in SDK"
    
     "${InstalledSoftware_path_GUI_dialog}"  --timeout 5 	--title "Information "    --msgbox "Installation Cancelled ...  "  20 80 
    int_user
    ;;
esac

# ################## # ##################
# ################## # ##################
# ###### Choose a provided IDE
# ################## # ##################
# ################## # ##################

targetListIDEDesc=$( find "${install_box_dir}/archs/${SYSTEM_HOST}/host/ide" -name "desc.txt" -type f  | sed -e "s;\.\/;;g" | grep -vi "\/ide\/desc"  | sort )
 
echo "" > /tmp/install_box_desc.tmp

for descfile in ${targetListIDEDesc[@]} ; do
    source $descfile
    
    system_desc=$( echo ${descfile} | xargs dirname | xargs basename   )
    editor_desc_dir=$( echo ${descfile} | xargs dirname ) 
    echo " == " $system_desc "...."  ${editor_desc}
    
    echo ${editor_desc}    | sed -e "s;\(.*$\);\"${editor_desc}xx\_${editor_desc_dir}\" \"Use ${SYSTEM_HOST} :: Editor Integration : \1\" off 0 xxzzxx;g" >> /tmp/install_box_desc.tmp
done

# ################## # ##################
# ################## # ##################

targetList=$( cat /tmp/install_box_desc.tmp )

# ################## # ##################
# ################## # ##################

source "${install_box_dir}/archs/${SYSTEM_HOST}/host/ide/desc.txt"
  
# ################## # ##################
# ################## # ##################

cat > /tmp/install_box.tmp <<EOF
#!/bin/bash

"${InstalledSoftware_path_GUI_dialog}" --title "Installation of ${SYSTEM_HOST} " \
    --treeview "Choose your IDE / Text Editor \\n
    ${ediitor_desc}" 32 120 0 \
    "none:none" "I already have one" off 0 \
    $( echo ${targetList[@]} | sed -e "s;xxzzxx;\
    ;g" )   
EOF
 
dailog_result=$( sh /tmp/install_box.tmp 2>&1 && true && echo $? )
echo "::::" $dailog_result
 
switch_case=$( echo ${dailog_result} | tr "xx_" "\\n" |  tail -n1 | awk '{if(length($2)){print $2}else{print $1}}' )
 
case  $switch_case  in
  0)
    echo "Yes chosen.";;
 
  *)
    echo "Box closed."
    
     "${InstalledSoftware_path_GUI_dialog}"  --timeout 5 	--title "Information "    --msgbox "Installation Cancelled ...  "  20 80 
    int_user
    ;;
esac

editor_choose=$( echo $dailog_result | tr "xx_" "\\n"  | tail -n1  )
editor_choosetxt=$( echo $dailog_result | tr "xx_" "\\n" | head -n1  )

echo $editor_choose"::::" $editor_choosetxt


if [ "${#SDK_STYLE}" -lt 2 ]; then
    productCrossPorting_Folder="/Developer/${productCrossPorting_default_Name}/${productCrossPorting_default_Version}"
else
    productCrossPorting_Folder="${SDK_STYLE_PATH}"
fi
echo "=== ${productCrossPorting_Folder} "


SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url=$( echo ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url} | sed -e "s;\({\([a-zA-Z0-9_]*\)}\);$\1;g" | sed -e "s;\ ;;g" | xargs echo )

 # ## finalised build declaration
 # ## rebuild and overided by THIS script AFTER First Default Build
cat >> "${INSTALL_SCRIPT_DEF}" <<EOF


SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url="${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url}"


SYSTEM_TARGET_IDEGUI_APP_sdk="${SDK_STYLE_PATH}"

SDK_STYLE="${SDK_STYLE}"
SDK_STYLE_PATH="${SDK_STYLE_PATH}"


productCrossPorting_Folder="${productCrossPorting_Folder}"

productCrossPorting_Name="${productCrossPorting_default_Name}"

productCrossPorting_Target="${productCrossPorting_Target}"

# ## gcc or llvm or another choosed-up
productCrossPorting_compiler="${compiler_choose_host}"

productCrossPorting_Target_arch="${productCrossPorting_Target_arch}"
productCrossPorting_Target_arch_wordSize="${productCrossPorting_Target_arch_wordSize}"
productCrossPorting_Target_compiler="${compiler_choose_target}"


productCrossPorting_downloadFolder="${productCrossPorting_Folder}/tmp/Downloads"
productCrossPorting_sourceFolder="${productCrossPorting_Folder}/tmp/Source"
productCrossPorting_binFolder="${productCrossPorting_Folder}/bin"

productCrossPorting_Target_Folder_arch="${productCrossPorting_Folder}/${productCrossPorting_Target_arch}"

productCrossPorting_Target_compiler="${compiler_choose_target}"
productCrossPorting_Target_compiler_name="${compiler_choose_target}"
productCrossPorting_Target_compiler_version="${compiler_choose_target_version}"
productCrossPorting_Target_compiler_version_Date="${compiler_choose_target_version_date}"
productCrossPorting_Target_compiler_dir_name="${productCrossPorting_Target_arch}-${productCrossPorting_Target_compiler_name}/"
productCrossPorting_Target_compiler_dir_system="${productCrossPorting_Folder}/system/${productCrossPorting_Target_compiler_dir_name}"
 

productCrossPorting_Target_compiler_dir_build_platform="${productCrossPorting_Folder}/build/${productCrossPorting_Target}/${productCrossPorting_Target_arch}"
productCrossPorting_Target_compiler_dir_base_platform="${productCrossPorting_Folder}/${productCrossPorting_Target}/${productCrossPorting_Target_arch}"
productCrossPorting_Target_compiler_dir_base_interface="${productCrossPorting_Folder}/PlatformInterfaces/"
productCrossPorting_Target_compiler_dir_base_interface_compiler="${productCrossPorting_Folder}/PlatformInterfaces/${productCrossPorting_Target_compiler}"
productCrossPorting_Target_compiler_basedir="${productCrossPorting_Target_compiler_dir_base_platform}/${productCrossPorting_Target_compiler}${productCrossPorting_Target_compiler_version}/"

productCrossPorting_Host_compiler="${compiler_choose_host}"
productCrossPorting_Host_compiler_name="${compiler_choose_host}"
productCrossPorting_Host_compiler_version="${compiler_choose_host_version}"
productCrossPorting_Host_compiler_version_Date="${compiler_choose_host_version_date}"
productCrossPorting_Host_compiler_basedir="${productCrossPorting_Target_compiler_dir_base_platform}/${productCrossPorting_Host_compiler}-${productCrossPorting_Host_compiler_version}/"

EOF

source "${INSTALL_SCRIPT_DEF}"


cat > /tmp/install_box.tmp <<EOF
#!/bin/bash

"${InstalledSoftware_path_GUI_dialog}" 	--title "Resume for Installation Targeting ${productCrossPorting_Target} " \
        --fill \
        --ok-label "Continue with this parameters"  \
        --cancel-label "Cancel installation" \
        --yesno " Installation wil use  the following in platform/SDK   \n \\
        Target : ${productCrossPorting_Target} \n \\
        Target Version : ${productCrossPorting_Target_default_version} \n \\
        \\n \\
        Compiler Host/Native    : ${productCrossPorting_Host_compiler} \\n \\
        Compiler Host/Version   : ${productCrossPorting_Host_compiler_version}${productCrossPorting_Host_compiler_version_Date} \\n \\
        Compiler arch           : ${productCrossPorting_Target_arch} \\n \\
        Compiler align          : ${productCrossPorting_Target_arch_wordSize} \\n \\
        \\n \\
        Compiler Target         : ${productCrossPorting_Target_compiler} \\n \\
        Compiler Target/Version : ${productCrossPorting_Target_compiler_version}${productCrossPorting_Target_compiler_version_Date} \\n \\
        Compiler arch           : ${productCrossPorting_Target_arch} \\n \\
        Compiler align          : ${productCrossPorting_Target_arch_wordSize} \\n \\
        \\n \\
        Editor / IDE            : ${editor_choosetxt} \\n \\
        \\n \\
        Final Path              : ${productCrossPorting_Folder} \\n \\
   "  30 160 120     
EOF

dailog_result=$( sh /tmp/install_box.tmp 2>&1  && echo $?  && echo "cc" || echo $? && echo "vv"    )
echo "::Resume::" $dailog_result
switch_case=$( echo ${dailog_result} | awk '{print $1}' )
case  $switch_case  in
  0)
    echo "Yes chosen.";;
   
  *)
    echo "Box closed."
    
     "${InstalledSoftware_path_GUI_dialog}"  --timeout 5 	--title "Information "    --msgbox "Installation Cancelled ...  "  20 80 
    int_user
    ;;
esac

# ################## # ##################
# ################## # ################## 
# ###### Resuming installation parameters ...
# ################## # ################## 

compteur=10
titrebarre="Dummy Dialog :: Installation in progress"
object_progress="..."

(
while test $compteur != 110
do
echo ${compteur}
echo "XXX"
echo "${titrebarre} ${compteur}\n\m pourcent \ncopie : ${object_progress}"
echo "XXX"
compteur=`expr $compteur + 10`
sleep 0.5
if [ ${compteur} -gt 80 ]; then
    titrebarre="Finalisation de l'installation, presque Fini ..."
fi
done
) |
$InstalledSoftware_path_GUI_dialog --title "${titrebarre}" --gauge "Bonjour, ceci est une barre d'avancement" 20 70 0

# ## note :: sed -e "s;\({\([a-zA-Z0-9_]*\)}\);$\2;g"

