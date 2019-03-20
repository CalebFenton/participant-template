Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

# Don't set this before Set-ExecutionPolicy as it throws an error
$ErrorActionPreference = "stop"

# CUSTOMIZE_HERE
# This is where you'd download or copy in your scanner binary using PowerShell.

# CUSTOMIZE_HERE
# As needed, download or copy Python wheel files into the wheel directory for installation.
&"pip" install @(Get-ChildItem -Recurse -Filter *.whl)

[System.Environment]::SetEnvironmentVariable('POLYSWARM_ENGINE', '{{ cookiecutter.engine_name_slug }}', 'machine')

# You can configure all polyswarm service's logging here
nssm set worker AppParameters "--log WARN"
nssm set worker Start SERVICE_DEMAND_START

# Balancemanager also accepts a 'maximum' parameter
nssm set balancemanager AppParameters "--minimum 10000000 --refill-amount 10000000"

nssm install microengine c:\Python35\Scripts\microengine.exe """--backend {{ cookiecutter.package_slug }}"""
nssm set microengine AppDirectory C:\{{ cookiecutter.engine_name }}
nssm set microengine AppExit Default Restart
nssm set microengine AppRestartDelay 250
nssm set microengine AppStdOut c:\engine.log
nssm set microengine AppStdErr c:\engine.log
nssm set microengine Start SERVICE_DISABLED
