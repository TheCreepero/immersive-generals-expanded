BeforeAll {
    $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $script:CharactersDir = Join-Path $script:RepoRoot "common\characters"
    $script:OnActionsDir = Join-Path $script:RepoRoot "common\on_actions"
    $script:InterfaceDir = Join-Path $script:RepoRoot "interface"
    $script:LocDir = Join-Path $script:RepoRoot "localisation\english"

    $script:CharacterFiles = @(Get-ChildItem -Path $script:CharactersDir -Filter "*.txt" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })
    $script:OnActionFiles = @(Get-ChildItem -Path $script:OnActionsDir -Filter "*.txt" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })
    $script:GfxFiles = @(Get-ChildItem -Path $script:InterfaceDir -Filter "*.gfx" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })
    $script:LocFiles = @(Get-ChildItem -Path $script:LocDir -Filter "*.yml" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })
}

Describe "Characters & Leaders: Directory Structure Invariants" {
    It "Characters directory exists" {
        Test-Path $script:CharactersDir | Should -Be $true
    }

    It "Interface directory exists" {
        Test-Path $script:InterfaceDir | Should -Be $true
    }

    It "Localisation english directory exists" {
        Test-Path $script:LocDir | Should -Be $true
    }

    It "On actions directory exists" {
        Test-Path $script:OnActionsDir | Should -Be $true
    }
}

Describe "Characters & Leaders: Script File Invariants" {
    Context "Character Script File: <_.Name>" -ForEach (@(Get-ChildItem -Path (Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "common\characters") -Filter "*.txt" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })) -AllowNullOrEmptyForEach {
        BeforeAll {
            $script:CurrentFile = $_
            $script:RawBytes = [System.IO.File]::ReadAllBytes($script:CurrentFile.FullName)
            $script:FileText = [System.IO.File]::ReadAllText($script:CurrentFile.FullName, [System.Text.Encoding]::UTF8)
            $script:CleanText = ($script:FileText -replace '(?m)#.*$', '')
        }

        It "Must be saved as UTF-8 without BOM" {
            $hasBom = ($script:RawBytes.Length -ge 3 -and $script:RawBytes[0] -eq 0xEF -and $script:RawBytes[1] -eq 0xBB -and $script:RawBytes[2] -eq 0xBF)
            $hasBom | Should -Be $false
        }

        It "Must have strictly balanced curly braces" {
            $openB = ([regex]::Matches($script:CleanText, '\{')).Count
            $closeB = ([regex]::Matches($script:CleanText, '\}')).Count
            $openB | Should -Be $closeB
        }

        It "Must have balanced double quotes" {
            $quoteCount = ([regex]::Matches($script:CleanText, '"')).Count
            ($quoteCount % 2) | Should -Be 0
        }
    }

    Context "On Actions File: <_.Name>" -ForEach (@(Get-ChildItem -Path (Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "common\on_actions") -Filter "*.txt" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })) -AllowNullOrEmptyForEach {
        BeforeAll {
            $script:CurrentActionFile = $_
            $script:RawActionBytes = [System.IO.File]::ReadAllBytes($script:CurrentActionFile.FullName)
            $script:ActionText = [System.IO.File]::ReadAllText($script:CurrentActionFile.FullName, [System.Text.Encoding]::UTF8)
            $script:CleanActionText = ($script:ActionText -replace '(?m)#.*$', '')
        }

        It "Must be saved as UTF-8 without BOM" {
            $hasBom = ($script:RawActionBytes.Length -ge 3 -and $script:RawActionBytes[0] -eq 0xEF -and $script:RawActionBytes[1] -eq 0xBB -and $script:RawActionBytes[2] -eq 0xBF)
            $hasBom | Should -Be $false
        }

        It "Must have strictly balanced curly braces" {
            $openB = ([regex]::Matches($script:CleanActionText, '\{')).Count
            $closeB = ([regex]::Matches($script:CleanActionText, '\}')).Count
            $openB | Should -Be $closeB
        }

        It "Must have balanced double quotes" {
            $quoteCount = ([regex]::Matches($script:CleanActionText, '"')).Count
            ($quoteCount % 2) | Should -Be 0
        }
    }

    Context "Interface GFX File: <_.Name>" -ForEach (@(Get-ChildItem -Path (Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "interface") -Filter "*.gfx" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })) -AllowNullOrEmptyForEach {
        BeforeAll {
            $script:CurrentGfxFile = $_
            $script:RawGfxBytes = [System.IO.File]::ReadAllBytes($script:CurrentGfxFile.FullName)
            $script:GfxText = [System.IO.File]::ReadAllText($script:CurrentGfxFile.FullName, [System.Text.Encoding]::UTF8)
            $script:CleanGfxText = ($script:GfxText -replace '(?m)#.*$', '')
        }

        It "Must be saved as UTF-8 without BOM" {
            $hasBom = ($script:RawGfxBytes.Length -ge 3 -and $script:RawGfxBytes[0] -eq 0xEF -and $script:RawGfxBytes[1] -eq 0xBB -and $script:RawGfxBytes[2] -eq 0xBF)
            $hasBom | Should -Be $false
        }

        It "Must have strictly balanced curly braces" {
            $openB = ([regex]::Matches($script:CleanGfxText, '\{')).Count
            $closeB = ([regex]::Matches($script:CleanGfxText, '\}')).Count
            $openB | Should -Be $closeB
        }

        It "Must have balanced double quotes" {
            $quoteCount = ([regex]::Matches($script:CleanGfxText, '"')).Count
            ($quoteCount % 2) | Should -Be 0
        }
    }

    Context "Localisation File: <_.Name>" -ForEach (@(Get-ChildItem -Path (Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "localisation\english") -Filter "*.yml" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike ".*" })) -AllowNullOrEmptyForEach {
        BeforeAll {
            $script:CurrentLocFile = $_
            $script:LocBytes = [System.IO.File]::ReadAllBytes($script:CurrentLocFile.FullName)
            $script:LocText = [System.IO.File]::ReadAllText($script:CurrentLocFile.FullName, [System.Text.Encoding]::UTF8)
        }

        It "Must be saved as UTF-8 with BOM" {
            $hasBom = ($script:LocBytes.Length -ge 3 -and $script:LocBytes[0] -eq 0xEF -and $script:LocBytes[1] -eq 0xBB -and $script:LocBytes[2] -eq 0xBF)
            $hasBom | Should -Be $true
        }

        It "Must start with l_english: header" {
            $script:LocText | Should -Match '(?m)^l_english:\s*$'
        }
    }
}
