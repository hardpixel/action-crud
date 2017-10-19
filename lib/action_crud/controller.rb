module ActionCrud
  module Controller
    extend ActiveSupport::Concern

    included do
      # Class attributes
      class_attribute :model_name,       instance_predicate: false
      class_attribute :model_class,      instance_predicate: false
      class_attribute :instance_name,    instance_predicate: false
      class_attribute :collection_name,  instance_predicate: false
      class_attribute :index_scope,      instance_predicate: false
      class_attribute :permitted_params, instance_predicate: false

      # Class attributes defaults
      self.permitted_params = []

      # Set class attributes
      set_model_name
      set_model_class
      set_index_scope

      # Action callbacks
      before_action :set_record, only: [:show, :edit, :update, :destroy]
    end

    class_methods do
      # Set permitted parameters
      def permit_params(options={})
        default = { only: model_class.attribute_names, except: [], also: [], array: [], hash: [] }
        options = Hash[default.merge(options).map { |k, v| [k, Array(v).map(&:to_sym)] }]
        permit  = options.except(:except).values.flatten.uniq

        permit.reject! { |a| a.blank? || a.in?(options[:except] + [:id]) }
        permit.map!    { |a| a.in?(options[:array]) ? [a => []] : a }
        permit.map!    { |a| a.in?(options[:hash])  ? [a => {}] : a }

        self.permitted_params = permit
      end

      # Set model name
      def set_model_name(name=nil)
        self.model_name      = (name || controller_name.classify).constantize.model_name
        self.instance_name   = model_name.singular
        self.collection_name = model_name.plural
      end

      # Set model class
      def set_model_class(klass=nil)
        self.model_class = klass || model_name.instance_variable_get('@klass')
      end

      # Set index scope
      def set_index_scope(scope='all')
        self.index_scope = scope.to_sym
      end
    end

    # GET /model
    def index
      self.records = model.send index_scope
      self.records = paginate(records) if respond_to? :per_page

      respond_to do |format|
        format.html { render :index }
        format.json { render json: records }
      end
    end

    # GET /model/new
    def new
      self.record = model.new

      respond_to do |format|
        format.html { render :new }
        format.json { render json: record }
      end
    end

    # GET /model/1
    def show
      respond_to do |format|
        format.html { render :show }
        format.json { render json: record }
      end
    end

    # GET /model/1/edit
    def edit
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: record }
      end
    end

    # POST /model
    def create
      self.record = model.new(record_params)

      respond_to do |format|
        if record.save
          format.html { redirect_to edit_record_path(record), notice: "#{model} was successfully created." }
          format.json { render json: record, status: :created }
        else
          format.html { render :new }
          format.json { render json: record.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /model/1
    def update
      respond_to do |format|
        if record.update(record_params)
          format.html { redirect_to edit_record_path(record), notice: "#{model} was successfully updated." }
          format.json { render json: record, status: :ok }
        else
          format.html { render :edit }
          format.json { render json: record.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /model/1
    def destroy
      record.destroy

      respond_to do |format|
        format.html { redirect_to records_path, notice: "#{model} was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # Get model
    def model
      model_class
    end

    alias :current_model :model

    # Get single record
    def record
      instance_variable_get "@#{instance_name}"
    end

    alias :current_record :record

    # Get records collection
    def records
      instance_variable_get "@#{collection_name}"
    end

    alias :current_records :records

    private

      # Set single record
      def record=(value)
        instance_variable_set "@#{instance_name}", value
      end

      # Set records collection
      def records=(value)
        instance_variable_set "@#{collection_name}", value
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_record
        self.record = model.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def record_params
        params.require(:"#{instance_name}").permit permitted_params
      end
  end
end
