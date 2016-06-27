#This build assumes the following directory structure
#
#  \               - This is where the project build code lives
#  \build          - This folder is created if it is missing and contains output of the build
#  \src            - This folder contains the source code or solutions you want to build
#

Framework "4.6"

Properties {
    $build_dir = Split-Path $psake.build_script_file    
    $build_artifacts_dir = "$build_dir\build\"
    $solution_file = "$build_dir\src\NPoco\NPoco.csproj"
}

FormatTaskName (("-"*25) + "[{0}]" + ("-"*25))

Task Default -Depends Clean, Build40, Build45

Task Build40 { 
    Write-Host "Building 4.0 $solution_file" -ForegroundColor Green
    Exec { msbuild "$solution_file" /t:Clean /p:Configuration=Release /v:quiet } 
    Exec { msbuild "$solution_file" /t:Build /p:Configuration=Release /v:quiet /p:TargetFrameworkVersion=v4.0 /p:OutDir="$build_artifacts_dir\net40\" /p:DefineConstants="NET40" } 
}

Task Build45  { 
    Write-Host "Building 4.5 $solution_file" -ForegroundColor Green
    Exec { msbuild "$solution_file" /t:Clean /p:Configuration=Release /v:quiet } 
    Exec { msbuild "$solution_file" /t:Build /p:Configuration=Release /v:quiet /p:TargetFrameworkVersion=v4.5 /p:OutDir="$build_artifacts_dir\net45\" /p:DefineConstants="NET45" } 
}

Task Clean {
    Write-Host "Creating BuildArtifacts directory" -ForegroundColor Green
    if (Test-Path $build_artifacts_dir) 
    {   
        rd $build_artifacts_dir -rec -force | out-null
    }
    
    mkdir $build_artifacts_dir | out-null
    
    Write-Host "Cleaning $solution_file" -ForegroundColor Green
}