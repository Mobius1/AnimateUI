function InitZoomAnimations(loop)
    AnimateUI.ZoomIn("ZoomIn / ZoomOut", 1000, 1500, "ZoomOut", function()
        if loop then
            InitSlideAnimations(loop)
        end
    end)
end

function InitFadeAnimations(loop)
    AnimateUI.FadeIn("FadeIn / FadeOut", 1000, 1500, "FadeOut", function()
        AnimateUI.FadeInDown("FadeInDown / FadeOutDown", 1000, 1500, "FadeOutDown", function()
            AnimateUI.FadeInUp("FadeInUp / FadeOutUp", 1000, 1500, "FadeOutUp", function()
                AnimateUI.FadeInLeft("FadeInLeft / FadeOutLeft", 1000, 1500, "FadeOutLeft", function()
                    AnimateUI.FadeInRight("FadeInRight / FadeOutRight", 1000, 1500, "FadeOutRight", function()
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
    AnimateUI.SlideInDown("SlideInDown / SlideOutDown", 1000, 1500, "SlideOutDown", function()
        AnimateUI.SlideInUp("SlideInUp / SlideOutUp", 1000, 1500, "SlideOutUp", function()
            AnimateUI.SlideInLeft("SlideInLeft / SlideOutLeft", 1000, 1500, "SlideOutLeft", function()
                AnimateUI.SlideInRight("SlideInRight / SlideOutRight", 1000, 1500, "SlideOutRight", function()
                    if loop then
                        InitFadeAnimations(loop)
                    end
                end)
            end)
        end)
    end)
end

function InitBounceAnimations(loop)
    AnimateUI.BounceIn("BounceIn / BounceOut", 1000, 1500, "BounceOut", function()
        AnimateUI.BounceInDown("BounceInDown / BounceOutDown", 1000, 1500, "BounceOutDown", function()
            AnimateUI.BounceInUp("BounceInUp / BounceOutUp", 1000, 1500, "BounceOutUp", function()
                AnimateUI.BounceInLeft("BounceInLeft / BounceOutLeft", 1000, 1500, "BounceOutLeft", function()
                    AnimateUI.BounceInRight("BounceInRight / BounceOutRight", 1000, 1500, "BounceOutRight", function()
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
    AnimateUI.ElasticIn("ElasticIn / ElasticOut", 1000, 1500, "ElasticOut", function()
        AnimateUI.ElasticInDown("ElasticInDown / ElasticOutDown", 1000, 1500, "ElasticOutDown", function()
            AnimateUI.ElasticInUp("ElasticInUp / ElasticOutUp", 1000, 1500, "ElasticOutUp", function()
                AnimateUI.ElasticInLeft("ElasticInLeft / ElasticOutLeft", 1000, 1500, "ElasticOutLeft", function()
                    AnimateUI.ElasticInRight("ElasticInRight / ElasticOutRight", 1000, 1500, "ElasticOutRight")
                end)
            end)
        end)
    end)
end

function InitTypewriterAnimations(loop)
    AnimateUI.TypewriterIn("TypewriterIn / TypewriterOut", 100, 1000, "TypewriterOut", function()
        if loop then
            InitZoomAnimations(loop)
        end
    end)
end

function InitDemo()
    InitTypewriterAnimations(true)
end