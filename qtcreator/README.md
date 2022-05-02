After installation the following still needs to be done:

open qtcreator
Open tools -> options 

Select the Build & Run page on the left.
in the general tab change projects directory to %{Env:TUE_SYSTEM_DIR}/src

In Default Build Properties change default build directory to %{Env:CURRENT_CMAKE_BUILD_DIR}/%{Project:Name}`
