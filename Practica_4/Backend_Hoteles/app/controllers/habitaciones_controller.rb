class HabitacionesController < ActionController::API
  before_action :set_habitacion, only: [:show, :update, :destroy]

  # GET /habitaciones
  def index
    if params[:id].present?
      @habitaciones = Habitacion.where(id: params[:id])
    else
      @habitaciones = Habitacion.all()
    end

    render json: @habitaciones
  end

  # GET /habitaciones/:id
  def show
    render json: @habitacion
  end

  # POST /habitaciones
  def create
    @habitacion = Habitacion.new(habitacion_params)
    if @habitacion.save
      render json: @habitacion, status: :created
    else
      @habitacion = Habitacion.new(habitacion_params)
      if @habitacion.save
        render json: @habitacion, status: :created
      else
        render json: @habitacion.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /habitaciones/:id
  def update
    if @habitacion.update(habitacion_params)
      render json: @habitacion
    else
      render json: @habitacion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /habitaciones/:id
  def destroy
    if @habitacion.destroy
      head :ok
    else
      render json: { error: "No se pudo eliminar" }, status: :unprocessable_entity
    end
  end

  private

  def set_habitacion
    @habitacion = Habitacion.find_by(id: params[:id])
    render json: { error: "Habitación no encontrada" }, status: :not_found unless @habitacion
  end

  def habitacion_params
    params.require(:habitacion).permit(:capacidad, :precio, :esta_ocupada, :nodo_hoja, :id_padre, :nombre, :tipo, :num_Habitacion)
  end

  # Determina si se debe usar rollback - solo en tests unitarios reales
  def should_use_rollback?
    # Usar rollback solo cuando estamos en tests unitarios, no en servidor de test
    Rails.env.test? && !server_mode?
  end

  # Detecta si estamos ejecutando un servidor (no tests unitarios)
  def server_mode?
    # Puedes usar diferentes métodos para detectar esto
    # Opción 1: Variable de entorno
    ENV['RAILS_SERVER_MODE'] == 'true' ||
    # Opción 2: Detectar si hay un servidor web ejecutándose
    defined?(Rails::Server) ||
    # Opción 3: Parámetro en la request
    params[:server_mode] == 'true'
  end
end

