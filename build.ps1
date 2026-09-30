#Requires -Version 7.0

param (
    [switch]$MakeZip
)

# Color palettes

$LightColors = @{
    primary = "rgb(236, 236, 236)"
    secondary = "rgb(242, 242, 242)"
    tertiary = "rgb(250, 250, 250)"
    translucent = "rgb(250, 250, 250, 97%)"
    border = "rgb(218, 218, 218)"
    text = "rgb(74, 74, 74)"
    text_inactive = "rgb(190, 190, 190)"
    active = "rgb(44, 146, 251)"
}

$DarkColors = @{
    primary = "rgb(30, 30, 30)"
    secondary = "rgb(30, 30, 30)"
    tertiary = "rgb(23, 23, 24)"
    translucent = "rgb(23, 23, 24, 97%)"
    border = "rgb(30, 30, 30)"
    text = "rgb(255, 255, 255)"
    text_inactive = "rgb(234, 234, 234)"
    active = "rgb(44, 146, 251)"
}

# Function to map color values to JSON keys

function Write-Colors {
    param ($InputColors)
    Write-Output @{
        frame = $InputColors.primary
        frame_inactive = $InputColors.primary
        toolbar_field = $InputColors.translucent
        toolbar_field_border = $InputColors.translucent
        toolbar_text = $InputColors.text
        toolbar_field_text = $InputColors.text
        toolbar_top_separator = $InputColors.secondary
        toolbar_bottom_separator = $InputColors.primary
        tab_selected = $InputColors.tertiary
        tab_text = $InputColors.text
        tab_line = $InputColors.border
        tab_background_text = $InputColors.text
        tab_background_text_inactive = $InputColors.text_inactive
        sidebar = $InputColors.tertiary
        sidebar_text = $InputColors.text
        sidebar_border = $InputColors.tertiary
        popup = $InputColors.translucent
        popup_text = $InputColors.text
        popup_highlight = $InputColors.active
        popup_border = $InputColors.translucent
        button_background_hover = $InputColors.secondary
        button_background_active = $InputColors.primary
        ntp_background = $InputColors.tertiary
    }
}

# Manifest file containing both themes and metadata

$Manifest = @{
    manifest_version = 2
    version = "2.0"
    name = "Cupertino: Unofficial macOS theme for Firefox"
    short_name = "Cupertino"
    author = "Corbin Davenport"
    description = "A Firefox theme designed to match the macOS color scheme and design."
    homepage_url = "https://github.com/corbindavenport/cupertino"
    icons = @{
        "32" = "icon_x32.png"
        "64" = "icon_x64.png"
        "128" = "icon_x128.png"
        "256" = "icon_x256.png"
    }
    theme = @{
        images = @{
            additional_backgrounds = "light_frame_right.svg", "light_frame_left.svg", "light_frame_center.svg"
        }
        properties = @{
            additional_backgrounds_alignment = "right top", "left top", "center top"
            additional_backgrounds_tiling = "no-repeat", "no-repeat", "repeat"
        }
        colors = Write-Colors $LightColors
    }
    dark_theme = @{
        images = @{
            # This is an empty array so the light theme backgrounds aren't used
            additional_backgrounds = [array[]]::new(0)
        }
        colors = Write-Colors $DarkColors
    }
}

# Create Firefox build

$FirefoxPath = Join-Path -Path "build" -ChildPath "firefox"
$null = New-Item -ItemType Directory -Force -Path $FirefoxPath
$FirefoxJson = Join-Path -Path $FirefoxPath -ChildPath "manifest.json"
ConvertTo-Json $Manifest -Depth 5 | Set-Content $FirefoxJson -Encoding UTF8
Copy-Item -Path $(Join-Path -Path "assets" -ChildPath "*") -Destination $FirefoxPath -Recurse -Force

# Create Firefox ZIP

if ($MakeZip) {
    $FirefoxFiles = Join-Path -Path $FirefoxPath -ChildPath "*"
    $FirefoxZip = Join-Path -Path "build" -ChildPath "firefox.zip"
    Compress-Archive -Path $FirefoxFiles -DestinationPath $FirefoxZip -Force
}