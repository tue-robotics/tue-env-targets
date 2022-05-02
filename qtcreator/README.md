# Setup qtcreator
After installation the following still needs to be done to configure qtcreator with the tue-environment:

1. open qtcreator
2. Open tools -> options 
3. Select the Build & Run page on the left.
    - in the general tab change projects directory to `%{Env:TUE_SYSTEM_DIR}/src`
    - In Default Build Properties change default build directory to `%{Env:CURRENT_CMAKE_BUILD_DIR}/%{Project:Name}`
