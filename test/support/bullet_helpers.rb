module BulletHelpers
  def with_bullet
    begin
      Bullet.enable = true
      Bullet.raise = true # raise an error if N+1 query occurs
      Bullet.counter_cache_enable = false
      Bullet.unused_eager_loading_enable = false
      Bullet.start_request
      yield
    ensure
      Bullet.end_request
      Bullet.enable = false
      Bullet.counter_cache_enable = true
      Bullet.unused_eager_loading_enable = true
      Bullet.raise = false
    end
  end
end
