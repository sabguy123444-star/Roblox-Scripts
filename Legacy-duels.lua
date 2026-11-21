-- ============================================================
-- legacy.vs
-- Black & Grey edition
-- ============================================================

-- ============================================================
-- LEGACY.VS INTRO GATE
-- Main script starts only after the intro finishes or is skipped.
-- ============================================================
repeat task.wait() until game:IsLoaded()

local _SoundIntroPlayers = game:GetService("Players")
local _SoundIntroRunService = game:GetService("RunService")
local _SoundIntroUIS = game:GetService("UserInputService")
local _SoundIntroLighting = game:GetService("Lighting")
local _SoundIntroSoundService = game:GetService("SoundService")
local _SoundIntroTweenService = game:GetService("TweenService")
local _SoundIntroPlayer = _SoundIntroPlayers.LocalPlayer

local _SOUND_INTRO_MUSIC_URL = "https://files.catbox.moe/y4q5y3.mp3"
local _SOUND_INTRO_MUSIC_FILE = "legacy_vs_intro_song.mp3"
local _SOUND_INTRO_MUSIC_VOLUME = 1
local _SOUND_INTRO_FALLBACK_MUSIC_ID = "rbxassetid://9046862121"
-- intro character asset removed

_G._SoundIntroFinished = false
_G._VantaSkipIntro = false
_G._VantaIntroActive = true

local function _soundResolveIntroMusicId()
    local assetGetter = getcustomasset or getsynasset
    if type(assetGetter) == "function" and type(writefile) == "function" then
        local exists = false
        if type(isfile) == "function" then
            pcall(function() exists = isfile(_SOUND_INTRO_MUSIC_FILE) end)
        end
        if not exists then
            local ok, data = pcall(function() return game:HttpGet(_SOUND_INTRO_MUSIC_URL) end)
            if ok and type(data) == "string" and #data > 0 then
                pcall(writefile, _SOUND_INTRO_MUSIC_FILE, data)
            end
        end
        local ok, asset = pcall(assetGetter, _SOUND_INTRO_MUSIC_FILE)
        if ok and asset then return asset end
    end
    return _SOUND_INTRO_FALLBACK_MUSIC_ID
end

local function _soundShowIntro(onFinished)
    local introSound
    local function stopIntroMusic()
        if introSound then
            pcall(function() introSound:Stop() end)
            pcall(function() introSound:Destroy() end)
            introSound = nil
        end
    end

    if _G._VantaLoadIntroCleanup then pcall(_G._VantaLoadIntroCleanup) end
    local isMobile = _SoundIntroUIS.TouchEnabled and not _SoundIntroUIS.KeyboardEnabled
    local playerGui = _SoundIntroPlayer:WaitForChild("PlayerGui")
    local old = playerGui:FindFirstChild("VantaLoadIntro")
    if old then old:Destroy() end
    local oldBlur = _SoundIntroLighting:FindFirstChild("VantaLoadIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VantaLoadIntro"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1000005
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    introSound = Instance.new("Sound")
    introSound.Name = "VantaIntroMusic"
    introSound.SoundId = _soundResolveIntroMusicId()
    introSound.Volume = _SOUND_INTRO_MUSIC_VOLUME
    introSound.Looped = false
    introSound.Parent = _SoundIntroSoundService
    pcall(function() introSound:Play() end)

    local instance = Instance.new("Frame")
    instance.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    instance.BackgroundTransparency = 1
    instance.BorderSizePixel = 0
    instance.Size = UDim2.fromScale(1, 1)
    instance.ZIndex = 1000
    instance.Parent = screenGui

    local rainContainer = Instance.new("Frame")
    rainContainer.Name = "PurpleRain"
    rainContainer.BackgroundTransparency = 1
    rainContainer.Size = UDim2.fromScale(1, 1)
    rainContainer.ZIndex = 1001
    rainContainer.ClipsDescendants = true
    rainContainer.Parent = instance

    local running = true
    local closing = false
    task.spawn(function()
        while running and not closing do
            local drop = Instance.new("Frame")
            drop.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
            drop.BackgroundTransparency = math.random(40, 70) / 100
            drop.BorderSizePixel = 0
            drop.Size = UDim2.fromOffset(math.random(1, 3), math.random(15, 30))
            drop.Position = UDim2.fromScale(math.random(0, 100) / 100, -0.1)
            drop.ZIndex = 1001
            drop.Parent = rainContainer
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = drop
            local fallTime = math.random(15, 25) / 10
            local tween = _SoundIntroTweenService:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
                Position = UDim2.fromScale(drop.Position.X.Scale, 1.1)
            })
            tween:Play()
            task.delay(fallTime + 0.1, function()
                if drop and drop.Parent then drop:Destroy() end
            end)
            task.wait(math.random(2, 6) / 100)
        end
    end)

    -- Character asset removed from intro
    local characterFrame = Instance.new("Frame")
    characterFrame.Name = "CharacterContainer"
    characterFrame.BackgroundTransparency = 1
    characterFrame.Visible = false
    characterFrame.Size = UDim2.fromOffset(1, 1)
    characterFrame.Parent = instance

    local frame2 = Instance.new("Frame")
    frame2.Name = "VantaWordmark"
    frame2.BackgroundTransparency = 1
    frame2.BorderSizePixel = 0
    frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    frame2.Position = UDim2.fromScale(0.5, 0.45)
    frame2.Size = isMobile and UDim2.fromOffset(280, 80) or UDim2.fromOffset(520, 120)
    frame2.ClipsDescendants = false
    frame2.ZIndex = 1003
    frame2.Parent = instance
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.86
    uiScale.Parent = frame2

    local titleLogo = Instance.new("TextLabel")
    titleLogo.Name = "LegacyTitle"
    titleLogo.BackgroundTransparency = 1
    titleLogo.Size = UDim2.fromScale(1, 1)
    titleLogo.Position = UDim2.fromScale(0, 0)
    titleLogo.Text = "legacy.vs"
    titleLogo.TextColor3 = Color3.fromRGB(220, 220, 230)
    titleLogo.TextTransparency = 1
    titleLogo.Font = Enum.Font.GothamBlack
    titleLogo.TextScaled = true
    titleLogo.ZIndex = 1004
    titleLogo.Parent = frame2
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(80, 80, 90)
    titleStroke.Thickness = 1.5
    titleStroke.Transparency = 0.4
    titleStroke.Parent = titleLogo

    -- keep empty wordmarkItems so animation loop still works
    local wordmarkItems = {}
    local wordmarkSpecs = {}

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "TAP ANYWHERE TO SKIP"
    textLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
    textLabel.TextTransparency = 1
    textLabel.TextSize = isMobile and 11 or 22
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
    textLabel.Size = UDim2.new(0.8, 0, 0, 24)
    textLabel.ZIndex = 1010
    textLabel.Parent = instance

    local textLabel2 = Instance.new("TextLabel")
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "legacy.vs"
    textLabel2.TextColor3 = Color3.fromRGB(160, 160, 170)
    textLabel2.TextTransparency = 1
    textLabel2.TextSize = isMobile and 10 or 16
    textLabel2.Font = Enum.Font.GothamMedium
    textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel2.Position = UDim2.new(0.5, 0, 0.88, 0)
    textLabel2.Size = UDim2.new(0.8, 0, 0, 22)
    textLabel2.ZIndex = 1010
    textLabel2.Parent = instance

    local skipBtn = Instance.new("TextButton")
    skipBtn.Name = "SkipAnywhereButton"
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.AutoButtonColor = false
    skipBtn.Size = UDim2.fromScale(1, 1)
    skipBtn.ZIndex = 1011
    skipBtn.Parent = instance

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "VantaLoadIntroBlur"
    blurEffect.Size = 0
    blurEffect.Parent = _SoundIntroLighting
    local canSkip = true

    local function smoothstep(a)
        local n = math.clamp(a, 0, 1)
        return n * n * (3 - 2 * n)
    end
    local function bezier(p0, p1, p2, t)
        local n = 1 - t
        return Vector2.new(n*n*p0.X + 2*n*t*p1.X + t*t*p2.X, n*n*p0.Y + 2*n*t*p1.Y + t*t*p2.Y)
    end

    local function closeIntro()
        if closing then return end
        closing = true
        running = false
        _G._VantaSkipIntro = true
        stopIntroMusic()
        local ti = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        _SoundIntroTweenService:Create(instance, ti, { BackgroundTransparency = 1 }):Play()
        _SoundIntroTweenService:Create(uiScale, ti, { Scale = 0.72 }):Play()
        _SoundIntroTweenService:Create(characterFrame, ti, { Position = UDim2.fromScale(0.5, 1.5) }):Play()
        _SoundIntroTweenService:Create(blurEffect, ti, { Size = 0 }):Play()
        _SoundIntroTweenService:Create(textLabel, ti, { TextTransparency = 1 }):Play()
        _SoundIntroTweenService:Create(textLabel2, ti, { TextTransparency = 1 }):Play()
        for _, item in ipairs(wordmarkItems) do
            if item.image then
                _SoundIntroTweenService:Create(item.image, ti, { ImageTransparency = 1 }):Play()
            end
        end
        if titleLogo then
            _SoundIntroTweenService:Create(titleLogo, ti, { TextTransparency = 1 }):Play()
        end
        task.delay(0.42, function()
            if screenGui.Parent then screenGui:Destroy() end
            if blurEffect.Parent then blurEffect:Destroy() end
            _G._VantaLoadIntroCleanup = nil
            _G._VantaIntroActive = false
            if onFinished then onFinished() end
        end)
    end

    _G._VantaLoadIntroCleanup = function()
        running = false
        closing = true
        stopIntroMusic()
        if screenGui.Parent then screenGui:Destroy() end
        if blurEffect.Parent then blurEffect:Destroy() end
        _G._VantaIntroActive = false
        _G._SoundIntroFinished = true
    end
    skipBtn.Activated:Connect(closeIntro)

    _SoundIntroTweenService:Create(instance, TweenInfo.new(0.25), { BackgroundTransparency = 0.5 }):Play()
    _SoundIntroTweenService:Create(blurEffect, TweenInfo.new(0.25), { Size = 10 }):Play()
    task.delay(0.35, function()
        if not running then return end
        if titleLogo then
            _SoundIntroTweenService:Create(titleLogo, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
        end
    end)
    task.delay(1.5, function()
        if not running then return end
        _SoundIntroTweenService:Create(textLabel, TweenInfo.new(0.3), { TextTransparency = 0.22 }):Play()
        _SoundIntroTweenService:Create(textLabel2, TweenInfo.new(0.3), { TextTransparency = 0.18 }):Play()
    end)

    task.spawn(function()
        local now = os.clock()
        while running and not closing do
            local animTime = os.clock() - now - 0.5
            if animTime > 0 then
                local v = smoothstep((animTime - 0.38) / 0.9)
                local s1 = math.sin(animTime * 1.62) * v
                local s2 = math.sin(animTime * 3.24) * v
                uiScale.Scale = 0.86 + smoothstep(animTime / 0.78) * 0.14 + s1 * 0.012
                for i, item in ipairs(wordmarkItems) do
                    local spec = item.spec
                    local offset = i - 3
                    local distance = math.abs(offset) / 2
                    local progress = math.clamp((animTime - spec.delay) / 0.96, 0, 1)
                    local eased = 1 - (1 - progress)^3
                    local pos = bezier(spec.from, Vector2.new((spec.from.X + spec.final.X) * 0.5 - offset * 0.08, (spec.from.Y + spec.final.Y) * 0.5 + ((i % 2 == 0) and -0.23 or 0.23)), spec.final, eased)
                    item.slot.Position = UDim2.fromScale(pos.X + offset * s1 * 0.009, pos.Y + (distance*distance*12 - 6) * s1 / 230 + s2 * (1 - distance) * 2.4 / 230)
                    item.slot.Size = UDim2.fromScale(0.15 * (1 + s1 * (0.035 + distance*0.055)), 0.65 - s1 * (0.028 + distance*0.045))
                    item.slot.Rotation = spec.rotation * (1 - eased) + offset * s1 * 5.8 + s2 * (1 - distance) * 0.8
                    local a = math.sin(animTime * 2.85 + i * 0.82)
                    local b = math.sin(animTime * 2.1 + i * 0.64)
                    item.image.Position = UDim2.new(0.5, 0, 0.5, b * 1.35)
                    item.image.Size = UDim2.fromScale(1 + a * 0.026, 1 - a * 0.038)
                    item.image.Rotation = b * 0.9
                    item.image.ImageTransparency = 1 - smoothstep((progress - 0.02) / 0.18)
                end
            end
            _SoundIntroRunService.RenderStepped:Wait()
        end
    end)

    task.delay(10, function()
        if running and not closing then closeIntro() end
    end)
end

_soundShowIntro(function()
    _G._SoundIntroFinished = true
    print("[legacy.vs] Intro finished — loading main script...")
end)

repeat task.wait() until _G._SoundIntroFinished == true
print("[legacy.vs] Intro finished. Starting main script.")
-- ============================================================
-- END LEGACY.VS INTRO GATE
-- ============================================================

-- ============================================================
-- FAST EXECUTION + PERFORMANCE FFLAGS
-- Applied as early as possible for lower latency / higher FPS
-- ============================================================
do
    local function _ehSetFFlag(name, value)
        local ok = false
        if type(setfflag) == "function" then
            ok = pcall(setfflag, name, value)
        end
        if not ok and type(setfflag) ~= "function" then
            -- some executors expose setflag / set_fflag
            if type(setflag) == "function" then
                pcall(setflag, name, value)
            elseif type(set_fflag) == "function" then
                pcall(set_fflag, name, value)
            end
        end
    end

    -- Bool / string FFlags
    _ehSetFFlag("DFFlagBrowserTrackerIdTelemetryEnabled", "False")
    _ehSetFFlag("DFFlagPreloadAsyncSupportTexturePack", "True")
    _ehSetFFlag("DFFlagTextureQualityOverrideEnabled", "True")
    _ehSetFFlag("DFFlagVideoCaptureServiceEnabled", "False")
    _ehSetFFlag("DFFlagSampleAndRefreshRakPing", "True")
    _ehSetFFlag("DFFlagRakNetUseSlidingWindow4", "True")
    _ehSetFFlag("DFFlagCoreScriptTelemetry2", "False")
    _ehSetFFlag("DFFlagEnableSoundPreloading", "True")
    _ehSetFFlag("DFFlagOptimizePartsInPart", "True")
    _ehSetFFlag("DFFlagDisableDPIScale", "True")
    _ehSetFFlag("DFFlagDebugPerfMode", "True")

    -- Int FFlags (network / packets / raknet)
    _ehSetFFlag("DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000")
    _ehSetFFlag("DFIntRakNetClockDriftAdjustmentPerPingMillisecond", "100")
    _ehSetFFlag("DFIntPerformanceControlTextureQualityBestUtility", "-1")
    _ehSetFFlag("DFIntSignalRHubConnectionHeartbeatTimerRateMs", "1000")
    _ehSetFFlag("DFIntMaxReceiveToDeserializeLatencyMilliseconds", "15")
    _ehSetFFlag("DFIntMegaReplicatorNetworkQualityProcessorUnit", "10")
    _ehSetFFlag("DFIntNetworkInDeserializeLimitGameplayMsClient", "6")
    _ehSetFFlag("DFIntSignalRHubConnectionBaseRetryTimeMs", "100")
    _ehSetFFlag("DFIntClientPacketHealthyAllocationPercent", "20")
    _ehSetFFlag("DFIntTelemetryProfilerHundredthsPercentage", "0")
    _ehSetFFlag("DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1")
    _ehSetFFlag("DFIntNetworkInProcessLimitGameplayMsClient", "6")
    _ehSetFFlag("DFIntAnimationLodFacsVisibilityDenominator", "0")
    _ehSetFFlag("DFIntRaknetBandwidthPingSendEveryXSeconds", "1")
    _ehSetFFlag("DFIntSignalRCoreKeepAlivePingPeriodMs", "250")
    _ehSetFFlag("DFIntClientPacketMaxFrameMicroseconds", "200")
    _ehSetFFlag("DFIntSoundServiceCacheCleanupMaxAgeDays", "2")
    _ehSetFFlag("DFIntMaxProcessPacketsStepsPerCyclic", "5000")
    _ehSetFFlag("DFIntClientPacketExcessMicroseconds", "1000")
    _ehSetFFlag("DFIntMaxProcessPacketsStepsAccumulated", "0")
    _ehSetFFlag("DFIntWaitOnUpdateNetworkLoopEndedMS", "100")
    _ehSetFFlag("DFIntLargePacketQueueSizeCutoffMB", "1000")
    _ehSetFFlag("DFIntMaxProcessPacketsJobScaling", "10000")
    _ehSetFFlag("DFIntRakNetNakResendDelayRttPercent", "50")
    _ehSetFFlag("DFIntSignalRCoreServerTimeoutMs", "11100")
    _ehSetFFlag("DFIntDebugFRMQualityLevelOverride", "1")
    _ehSetFFlag("DFIntClientPacketMinMicroseconds", "1")
    _ehSetFFlag("DFIntAnimationLodFacsDistanceMin", "0")
    _ehSetFFlag("DFIntAnimationLodFacsDistanceMax", "0")
    _ehSetFFlag("DFIntWaitOnRecvFromLoopEndedMS", "100")
    _ehSetFFlag("DFIntRakNetNakResendDelayMsMax", "100")
    _ehSetFFlag("DFIntCodecMaxOutgoingFrames", "10000")
    _ehSetFFlag("DFIntSignalRCoreRpcQueueSize", "256")
    _ehSetFFlag("DFIntRakNetMinAckGrowthPercent", "0")
    _ehSetFFlag("DFIntTaskSchedulerTargetFps", "9999")
    _ehSetFFlag("DFIntCodecMaxIncomingPackets", "100")
    _ehSetFFlag("DFIntRakNetMtuValue3InBytes", "1200")
    _ehSetFFlag("DFIntRakNetMtuValue1InBytes", "1280")
    _ehSetFFlag("DFIntRakNetMtuValue2InBytes", "1240")
    _ehSetFFlag("DFIntRakNetNakResendDelayMs", "10")
    _ehSetFFlag("DFIntRakNetResendRttMultiple", "1")
    _ehSetFFlag("DFIntMemCacheMaxCapacityMB", "48")
    _ehSetFFlag("DFIntClientPacketMaxDelayMs", "11")
    _ehSetFFlag("DFIntTextureQualityOverride", "0")
    _ehSetFFlag("DFIntRakNetSelectTimeoutMs", "1")
    _ehSetFFlag("DFIntSignalRCoreTimerMs", "750")
    _ehSetFFlag("DFIntConnectionMTUSize", "1260")
    _ehSetFFlag("DFIntMaxFrameBufferSize", "4")
    _ehSetFFlag("DFIntRakNetLoopMs", "1")
    _ehSetFFlag("DFIntDebugRestrictGCDistance", "1")

    -- FInt flags
    _ehSetFFlag("FIntTaskSchedulerAsyncTasksMinimumThreadCount", "2")
    _ehSetFFlag("FIntRenderMaxShadowAtlasUsageBeforeDownscale", "80")
    _ehSetFFlag("FIntPerformanceTelemetryQueueProcessLimit", "0")
    _ehSetFFlag("FIntRenderShadowMapDepthCacheMemLimit", "192")
    _ehSetFFlag("FIntUITextureMaxRenderTextureSize", "1024")
    _ehSetFFlag("FIntRakNetResendBufferArrayLength", "128")
    _ehSetFFlag("FIntTaskSchedulerAutoThreadLimit", "6")
    _ehSetFFlag("FIntTerrainOTAMaxTextureSize", "1024")
    _ehSetFFlag("FIntOcclusionWorkerThreadCount", "5")
    _ehSetFFlag("FIntTaskSchedulerMaxNumOfJobs", "86")
    _ehSetFFlag("FIntTelemetryProfilerFrequency", "0")
    _ehSetFFlag("FIntRenderLocalLightFadeInMs", "0")
    _ehSetFFlag("FIntDefaultMeshCacheSizeMB", "256")
    _ehSetFFlag("FIntReportDeviceInfoRollout", "0")
    _ehSetFFlag("FIntTaskSchedulerThreadMin", "1")
    _ehSetFFlag("FIntRobloxGuiBlurIntensity", "0")
    _ehSetFFlag("FIntTerrainArraySliceSize", "0")
    _ehSetFFlag("FIntDebugForceMSAASamples", "1")
    _ehSetFFlag("FIntRenderShadowmapBias", "0")
    _ehSetFFlag("FIntFRMMaxGrassDistance", "0")
    _ehSetFFlag("FIntFRMMinGrassDistance", "0")
    _ehSetFFlag("FIntGrassMovementReducedMotionFactor", "0")
    _ehSetFFlag("FIntDebugTextureManagerSkipMips", "7")

    -- Render / quality / misc
    _ehSetFFlag("RenderUseTextureManager224", "False")
    _ehSetFFlag("TextureQualityOverride", "1")
    _ehSetFFlag("TextureQualityOverrideEnabled", "True")
    _ehSetFFlag("PerformanceControlTextureQualityBestUtility", "1")
    _ehSetFFlag("FFlagRenderAllocateShadowMapResourcesOnDemand", "True")
    _ehSetFFlag("FFlagSpecifyNetworkReplicatorScopeForItems", "True")
    _ehSetFFlag("FFlagTaskSchedulerLimitTargetFpsTo2402", "False")
    _ehSetFFlag("FFlagHandleAltEnterFullscreenManually", "False")
    _ehSetFFlag("FFlagGameBasicSettingsFramerateCap5", "False")
    _ehSetFFlag("FFlagSpecifyNetworkReplicatorScope", "True")
    _ehSetFFlag("FFlagSendRenderFidelityTelemetry2", "False")
    _ehSetFFlag("FFlagRenderGpuTextureCompressor", "True")
    _ehSetFFlag("FFlagBaseThrea