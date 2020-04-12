# This script aims to give more detail than the Get-Hotfix.  In particular this shows install status and an accurate install date.  
function Get-HotfixInfo {
  $Session = New-Object -ComObject "Microsoft.Update.Session"
  $Searcher = $Session.CreateUpdateSearcher()
  $historycount = $Searcher.GetTotalHistoryCount()
  $Searcher.QueryHistory(0, $historycount) | Select-Object Title, Description, Date,
  @{ name = "Operation"; expression = { switch ($_.operation) {
        1 { "Installation" }; 2 { "Uninstallation" }; 3 { "Other" };
      }
    }   
  },
  @{name = "Result"; expression = { switch ($_.ResultCode) {
        0 { "Not Started" }; 1 { "In Progress" }; 2 { "Succeeded" }; 3 { "Succeeded With Errors" }; 4 { "Failed" }; 5 { "Aborted" }; default { "Unknown" } 
      }
    }
  } ,
  @{name = "HotFixID"; expression = { 
      $_.title -match "\bKB[0-9]*\b" | Out-Null
      $($Matches.Values)
    }
  } 
}
