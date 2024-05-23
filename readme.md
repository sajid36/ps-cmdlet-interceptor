# PowerShell Cmdlet Hooking POC

## Overview
PowerShell cmdlet hooking lets us tweak and steer the behavior of specific PowerShell commands. For example, the Get-ChildItem command normally lists files in a directory. However, through cmdlet hooking, we can redirect it to list files from an entirely different directory without the user noticing any changes.

This capability provides complete control over PowerShell activities, proving beneficial for both attack and defense strategies. Offensive security teams (red teams) can discreetly alter system settings or manipulate actions to extract information covertly. Conversely, defensive teams (blue teams) can use this technique to monitor for malicious activities, potentially redirecting harmful scripts to achieve early detection or deceive attackers by feeding them false information. This method adds a strategic layer to cybersecurity practices, making it a dynamic tool for both sides.

## Files
- `TargetScript.ps1`: Script intended to run a standard `Get-ChildItem` command that lists files in a specified directory which is (decept_test).
- `HookScript.ps1`: Script that modifies the behavior of `Get-ChildItem`, redirecting any directory access to a fixed path which is (decept_test_fake).
- copy these folder/directory in the same location as the scripts

## Goal of the Experiment
To showcase the ability to intercept cmdlet functions in PowerShell and redirect directory listings to a new, predetermined directory, regardless of the original input path specified in the script.

## Prerequisites
- Operating System: Windows 10 or later
- PowerShell Version: 5.1 or higher

## Setup Instructions

### Step 1: Prepare Scripts
Ensure that both `TargetScript.ps1` and `HookScript.ps1` are downloaded to the same directory on your local machine.

### Step 2: Execute the Hook Script
Open a PowerShell terminal. Navigate to the directory containing the scripts and source the HookScript to modify the cmdlet behavior:

run: .\HookScript.ps1

### Step 3: Run the Target Script

With the hook in place, execute the TargetScript to observe the cmdlet behavior change:

run: .\TargetScript.ps1 on the same terminal 

## Expected Outcomes

When TargetScript.ps1 is executed, rather than showing results from its originally specified directory, it will list files from the directory specified in HookScript.ps1. This change confirms the successful redirection of the Get-ChildItem cmdlet.

![tempsnip](https://github.com/sajid36/ps-cmdlet-interceptor/assets/30213560/9965604a-2328-4a48-8514-28b8293dcd74)


