class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= Usuario.new # guest user (not logged in)
    producto ||= Producto.new

       if user.admin?
         can :manage, :all
       elsif user.signed_in?
          can :index, Categoria
          can :read, [Producto, Usuario]
          cannot :index, Usuario
          can :update, Producto do |producto|
            producto.try(:usuario) == user
          end
          can :create, Producto
          can :destroy, Producto do |producto|
            producto.try(:usuario) == user
          end
          can :read, Pedido, :distribuidor_id => user.id
          can :read, Pedido, :proveedor_id => user.id
          can :create, Pedido
          can :update, Pedido, :distribuidor_id => user.id
          can :update, Pedido, :proveedor_id => user.id

        else
          can :read, Producto
          can :read, Usuario
          cannot :index, Usuario
       end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
