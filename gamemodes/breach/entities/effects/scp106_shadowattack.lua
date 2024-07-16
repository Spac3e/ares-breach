function EFFECT:Init( data )

  self.pos = data:GetOrigin()
  self.life = 130
  self.alpha = 230
  self.rot = math.random( 1, 360 )

end

function EFFECT:Think()

  self.life = self.life - ( FrameTime() * 200 )

  if ( self.life < 50 ) then

    self.alpha = math.max( self.alpha - ( FrameTime() * 512 ), 0 )

  end

  if ( self.life < 0 ) then return false end

  return true
end

local render_mat = Material( "particles/smokey" )

function EFFECT:Render()

  render.SetMaterial( render_mat )
  render.DrawQuadEasy( self.pos, vector_up, self.life, self.life, ColorAlpha( color_black, self.alpha ), self.rot )

end
