namespace :migrate_data do
  desc "Migrate datas from old Java DB to new Rails DB"

  task :migrateStaffsDB => :environment do
    old_db = open_db
    old_staffs = old_db.execute("SELECT * FROM t_staff")

    new_staff = Staff.new(setStaffParams(old_staffs[0]))

    begin
      new_staff.save!
      puts "*** StaffsDB Migration successed ***"
    rescue => e
      puts e
      puts "*** StaffsDB Migration failed ***"
    end
  end

  task :migrateLeafsDB => :environment do
    old_db = open_db

    begin
      ActiveRecord::Base.transaction do

        # Migrating Leaf and Customer
        #old_customers = old_db.execute("SELECT * FROM t_customer order by valid_flag")
        old_customers = old_db.execute("SELECT * FROM t_customer where valid_flag = 1")
        
        old_customers.each do |old_customer|
          #Debug code
          #if old_customer[0] == 6431
          new_leaf = Leaf.new(setLeafParams(old_customer))
          new_leaf.save!

          #Migrating Contracts and first Seals
          old_contracts = old_db.execute(
            "SELECT * FROM t_contract where customer_id_fk = ? and money is not null",
            old_customer[0]
          )

          new_contracts = setContractsParams(new_leaf.id, old_contracts)

          new_contracts.each do |new_contract_params|
            new_contract = Contract.new(new_contract_params)
            new_contract.save!
          end

          #Migrating(Updating) the rest Seals
          old_seals = old_db.execute(
            "SELECT * FROM t_contract where customer_id_fk = ?",
            old_customer[0]
          )

          seals_ids = Seal.joins(:contract)
          .where("leaf_id = #{new_leaf.id}")
          .pluck('id')

          # Delete the first seal id and old record
          # because it's already written above.
          old_seals.delete_at(0)
          seals_ids.delete_at(0)

          seals_attributes = setSealsParams(old_seals)

          # If the size of new seal records and old contracts is differ,
          # something is wrong in migration.   
          unless seals_ids.size == old_seals.size
            raise "Error after Contracts migration!" 
          end

          Seal.update(seals_ids, seals_attributes)
          #end
        end
      end

      puts "*** LeafsDB Migration successed ***"
    rescue => e
      puts e
      puts "*** LeafsDB Migration failed ***"
    end
  end

  task :checkLeafsDB => :environment do
    SUCCESS_MESSAGE = "*** LeafsDB Check successed ***"
    FAILURE_MESSAGE = "*** LeafsDB Check failed ***"

    result_message = SUCCESS_MESSAGE

    old_db = open_db

    old_customers = old_db.execute("SELECT * FROM t_customer")

    old_customers.each do |old_customer|
      new_leaf = Leaf.new(setLeafParams(old_customer))

      # Checking Leaf and Customer parameters
      if new_leaf.invalid?
        puts new_leaf.errors.full_messages
        result_message = FAILURE_MESSAGE
        break
      end
    end

    puts result_message 
  end
end

  def open_db
    dbfile = 'lib/tasks/cyclepark.db'

  unless File.exists?(dbfile)
    puts "No such db file #{dbfile}."
    return
  end

  begin 
    db = SQLite3::Database.open(dbfile)
  rescue SQLite3::Exception => e
    puts e
    puts "*** Failed to open ***"
    return
  end
end

def setStaffParams(staff)
  staff_params = {
    nickname: staff[1],
    password: '12345678',
    admin_flag: staff[7],
    staffdetail_attributes: {
      name:'鳥居 洋介' ,
      read:'トリイ ヨウスケ',
      address: staff[3],
      birthday: staff[2],
      phone_number: staff[4],
      cell_number: staff[5]
    }
  }
end

def setLeafParams(customer)
  p [customer[1], customer[5], customer[6]]

  first_name, last_name = customer[5].split(/\p{blank}/)
  first_read, last_read = customer[6].split(/\p{blank}/)
  # Filling the space if last_read is nil because of unknown read
  last_read ||= ' '

  comment = (customer[12].empty?) ? nil : customer[12]

  leaf_params = {
    number: customer[1],
    vhiecle_type: customer[2],
    student_flag: customer[3],
    largebike_flag: customer[14],
    valid_flag: customer[4],
    start_date: customer[11],
    last_date: nil,
    customer_attributes: {
      first_name: first_name,
      last_name: last_name,
      first_read: first_read,
      last_read: last_read,
      sex: customer[10],
      address: customer[7],
      phone_number: customer[8],
      cell_number: customer[9],
      receipt: '不要',
      comment: comment
    }
  }
end


def setContractsParams(leaf_id, contracts)

  result = []

  contracts.each do |contract|
    result << {
      leaf_id: leaf_id,
      contract_date: contract[7],
      term1: contract[4].to_i,
      money1: contract[6].to_i,
      term2: 0,
      money2: 0,
      skip_flag: contract[6] == '休み',
      staff_nickname: contract[8],
      seals_attributes: [{ sealed_flag: contract[9] }]
    }
  end

  result
end

def setSealsParams(seals)

  result = []

  seals.each do |seal|
    result << {
      sealed_flag: seal[9],
      sealed_date: seal[10],
      staff_nickname: seal[11]
    }
  end

  result
end
