function InitZoomAnimations(loop)
    AnimateUI.ZoomIn("ZoomIn / ZoomOut", nil, 250, 1500, "ZoomOut", function()
        if loop then
            InitSlideAnimations(loop)
        end
    end)
end

function InitFadeAnimations(loop)
    AnimateUI.FadeIn("FadeIn / FadeOut", nil, 500, 1500, "FadeOut", function()
        AnimateUI.FadeInDown("FadeInDown / FadeOutDown", nil, 500, 1500, "FadeOutDown", function()
            AnimateUI.FadeInUp("FadeInUp / FadeOutUp", nil, 500, 1500, "FadeOutUp", function()
                AnimateUI.FadeInLeft("FadeInLeft / FadeOutLeft", nil, 500, 1500, "FadeOutLeft", function()
                    AnimateUI.FadeInRight("FadeInRight / FadeOutRight", nil, 500, 1500, "FadeOutRight", function()
                        if loop then
                            InitBounceAnimations(loop)
                        end
                    end)
                end)
            end)
        end)
    end)
end

function InitSlideAnimations(loop)
    AnimateUI.SlideInDown("SlideInDown", nil, 500, 1500, nil, function()
        AnimateUI.SlideInUp("SlideInUp", nil, 500, 1500, nil, function()
            AnimateUI.SlideInLeft("SlideInLeft", nil, 500, 1500, nil, function()
                AnimateUI.SlideInRight("SlideInRight", nil, 500, 1500, nil, function()
                    if loop then
                        InitFadeAnimations(loop)
                    end
                end)
            end)
        end)
    end)
end

function InitBounceAnimations(loop)
    AnimateUI.BounceIn("BounceIn", nil, 1000, 1500, nil, function()
        AnimateUI.BounceInDown("BounceInDown ", nil, 1000, 1500, nil, function()
            AnimateUI.BounceInUp("BounceInUp", nil, 1000, 1500, nil, function()
                AnimateUI.BounceInLeft("BounceInLeft", nil, 1000, 1500, nil, function()
                    AnimateUI.BounceInRight("BounceInRight", nil, 1000, 1500, nil, function()
                        if loop then
                            InitElasticAnimations(loop)
                        end
                    end)
                end)
            end)
        end)
    end)
end

function InitElasticAnimations()
    AnimateUI.ElasticIn("ElasticIn", nil, 1000, 1500, nil, function()
        AnimateUI.ElasticInDown("ElasticInDown", nil, 1000, 1500, nil, function()
            AnimateUI.ElasticInUp("ElasticInUp", nil, 1000, 1500, nil, function()
                AnimateUI.ElasticInLeft("ElasticInLeft", nil, 1000, 1500, nil, function()
                    AnimateUI.ElasticInRight("ElasticInRight", nil, 1000, 1500, nil)
                end)
            end)
        end)
    end)
end

function InitTypewriterAnimations(loop)
    AnimateUI.TypewriterIn("TypewriterIn", nil, 100, 1000, nil, function()
        if loop then
            InitZoomAnimations(loop)
        end
    end)
end

function InitDemo()
    InitTypewriterAnimations(true)
end