# Carrierwave::ActiverecordStoreInModel

CarrierWave::ActiverecordStoreInModel is a CarrierWave plugin which stores file data
using ActiveRecord.  It relies on ActiveRecord for database
independence. It is based on Carrierwave::ActiveRecord.

## Why?

Carrierwave::ActiveRecord stores all files in one table, and retreives files by and identifier. In situations
where not everyone is supposed to retrieve all files (i.e. CanCan), this model doesn't work. Hence the need to store
the files in the table that is associated with the model.

## Caveat

At the moment, only one Uploader per model is supported. This is due to the fact that the columns that hold size, data,
content_type and identifier are not namespaced.
 
## Installation

### Add the gem

Add it to your Gemfile:

    gem 'carrierwave-activerecord-store-in-model'

And install:

    $ bundle

Or manually:

    $ gem install carrierwave-activerecord-store-in-model

## Usage

To use the ActiveRecord store, add the following to your uploader:

    storage :activerecord_store_in_model

## Storing files

By default, the gem uses the same table as the model, derived from 'model.table_name'. 
A migration is needed to add the following columns:

  * identifier: string
  * original_filename: string
  * content_type: string
  * size: integer
  * data: binary


### Rails

If you do not have a suitable table, you may generate a migration to
create the default table:

    $ rails g migration AddPictureToClient picture:string identifier:string original_filename:string content_type:string size:integer data:binary
    $ rake db:migrate

## The following part is copied from the original Carrierwave::ActiveRecord documentation and may not be accurate for this gem. 

### Outside Rails

If you are already using ActiveRecord as your ORM, the storage provider
will use the existing connection.  Thus, it will work in Rails without
any additional configuration.

If you are not using ActiveRecord as your ORM, you will need to setup
the connection to the database.


## Serving files


### Rails

When used with Rails, the gem attempts to follow routing conventions.

File URLs point to the resource on which the uploader is mounted, using
the mounted attribute name as the tail portion of the URL.

To serve the files while preserving security, add to your application's
routes and appropriate controllers.

For example:

Given a people resource with an uploader mounted on the avatar field:

```ruby
# app/models/person.rb
class Person < ActiveRecord::Base
  attr_accessible :avatar
  mount_uploader :avatar, AvatarUploader
end
```

Each avatar file will be available underneath it's corresponding person:

`/person/1/avatar`

Adding a member GET route to the resource will generate a named route
for use in controllers and views:

```ruby
# config/routes.rb
MyApp::Application.routes.draw do
  resources :people do
    # At the present time, resourcing files has not been tested.
    member { get 'avatar' }
end
```

Then implement the method `PeopleController#avatar` to serve the avatar:

```ruby
# app/controllers/people_controller.rb
class PeopleController

  # before_filters for auth, etc.
  # ...

  def avatar
    person = Person.find(params[:id])
    send_data(person.avatar.read, filename: person.avatar.file.filename)
  end
end
```


### Outside Rails: default routes

Without Rails, file URLs are generated from two parts.

  * the `downloader_path_prefix`, common to all files
  * the `identifier`, a SHA1 particular to each file

The path prefix is configurable in your CarrierWave configure block, as
`downloader_path_prefix`, the default is `/files`.

For example:

`GET /files/afdd0c3f8578270aae2bd1784b46cefa0bec8fa6 HTTP/1.1`


### Outside Rails: custom routes

Finally, you have the option of overriding the URL in each uploader:

```ruby
# app/uploaders/avatar_uploader.rb
class AvatarUploader < CarrierWave::Uploader::Base
  def url
    "/a/custom/url/to/avatar/#{uploader.model.id}"
  end
end
```


## Further reading

### An example project

The following example and test project tracks the gem: https://github.com/richardkmichael/carrierwave-activerecord-project

### How to add a storage provider

A work-in-progress guide to writing a CarrierWave storage provider is here: https://github.com/richardkmichael/carrierwave-activerecord/wiki/Howto:-Adding-a-new-storage-engine

```
[3] pry(#<CarrierWave::Mount::Mounter>)> self
=> #<CarrierWave::Mount::Mounter:0x00000102b67aa8
 @column=:file,
 @integrity_error=nil,
 @options={},
 @processing_error=nil,
 @record=
  #<ArticleFile id: 5, file: "my_uploaded_file.txt", article_id: 4, created_at: "2012-06-02 11:42:10", updated_at: "2012-06-02 11:42:10">,
 @uploader=,
 @uploader_options={:mount_on=>nil}>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request