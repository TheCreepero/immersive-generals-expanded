BeforeAll {
    $script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
    . (Join-Path $script:RepoRoot 'tools\HoiModBuild.ps1')
    $script:BuildConfig = Get-ModBuildConfig -RepoDir $script:RepoRoot
}

Describe 'build.ps1 configuration' {
    It 'ships the common, interface and localisation folders with the descriptor and thumbnail' {
        $shippedTopLevel = @(Get-ModContentFiles -Config $script:BuildConfig | ForEach-Object { ($_ -split '/')[0] } | Sort-Object -Unique)
        $shippedTopLevel | Should -Be @('common', 'descriptor.mod', 'interface', 'localisation', 'thumbnail.png') -Because 'gfx holds only .gitkeep placeholders so far'
    }

    It 'installs as immersive-generals-expanded and packages immersive-generals-expanded.zip' {
        $script:BuildConfig.ModFolderName | Should -Be 'immersive-generals-expanded'
        $script:BuildConfig.ZipArchiveName | Should -Be 'immersive-generals-expanded.zip'
        $script:BuildConfig.PackageLayout | Should -Be 'Flat'
    }
}
