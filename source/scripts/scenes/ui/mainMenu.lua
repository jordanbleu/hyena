local gfx <const> = playdate.graphics



class("MainMenu").extends(Scene)

function MainMenu:initialize(sceneManager)
    MainMenu.super.initialize(self, sceneManager)

    print ("hey im the main menu btw")

end