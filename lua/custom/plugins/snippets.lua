-- LuaSnip setup with Unreal Engine C++ snippets
return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    config = function()
      local ls = require 'luasnip'
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local rep = require('luasnip.extras').rep

      -- Load friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      ls.add_snippets('cpp', {

        -- AActor subclass
        s('uactor', {
          t 'UCLASS(Blueprintable)',
          t { '', 'class ' }, i(1, 'MYGAME_API'), t ' ', i(2, 'AMyActor'), t ' : public ', i(3, 'AActor'),
          t { '', '{', '\tGENERATED_BODY()', '', 'public:', '\t' },
          rep(2), t '();',
          t { '', '', 'protected:', '\tvirtual void BeginPlay() override;', '', 'public:',
            '\tvirtual void Tick(float DeltaTime) override;', '};' },
          i(0),
        }),

        -- UActorComponent subclass
        s('ucomp', {
          t 'UCLASS(ClassGroup=(Custom), meta=(BlueprintSpawnableComponent))',
          t { '', 'class ' }, i(1, 'MYGAME_API'), t ' ', i(2, 'UMyComponent'), t ' : public ', i(3, 'UActorComponent'),
          t { '', '{', '\tGENERATED_BODY()', '', 'public:', '\t' },
          rep(2), t '();',
          t { '', '', 'protected:',
            '\tvirtual void BeginPlay() override;',
            '',
            'public:',
            '\tvirtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;',
            '};',
          },
          i(0),
        }),

        -- UPROPERTY
        s('uprop', {
          t 'UPROPERTY(', i(1, 'EditAnywhere, BlueprintReadWrite'), t ', Category = "', i(2, 'MyCategory'), t '")',
          t { '', '' }, i(3, 'float'), t ' ', i(4, 'MyProperty'), t ';',
          i(0),
        }),

        -- UFUNCTION
        s('ufunc', {
          t 'UFUNCTION(', i(1, 'BlueprintCallable'), t ', Category = "', i(2, 'MyCategory'), t '")',
          t { '', '' }, i(3, 'void'), t ' ', i(4, 'MyFunction'), t '(', i(5), t ');',
          i(0),
        }),

        -- UE_LOG
        s('ulog', {
          t 'UE_LOG(', i(1, 'LogTemp'), t ', ', i(2, 'Warning'), t ', TEXT("', i(3, 'message'), t '"));',
          i(0),
        }),

        -- UE_LOG with format args
        s('ulogf', {
          t 'UE_LOG(', i(1, 'LogTemp'), t ', ', i(2, 'Warning'), t ', TEXT("', i(3, '%s'), t '"), ', i(4, 'value'), t ');',
          i(0),
        }),

        -- BeginPlay implementation
        s('beginplay', {
          t 'void ', i(1, 'AMyActor'), t '::BeginPlay()',
          t { '', '{', '\tSuper::BeginPlay();', '\t' },
          i(0),
          t { '', '}' },
        }),

        -- Tick implementation
        s('tick', {
          t 'void ', i(1, 'AMyActor'), t '::Tick(float DeltaTime)',
          t { '', '{', '\tSuper::Tick(DeltaTime);', '\t' },
          i(0),
          t { '', '}' },
        }),

        -- TickComponent implementation (for components)
        s('tickcomp', {
          t 'void ', i(1, 'UMyComponent'), t '::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)',
          t { '', '{', '\tSuper::TickComponent(DeltaTime, TickType, ThisTickFunction);', '\t' },
          i(0),
          t { '', '}' },
        }),

        -- DECLARE_LOG_CATEGORY_EXTERN (usually in MyGame.h)
        s('ulogcat', {
          t 'DECLARE_LOG_CATEGORY_EXTERN(', i(1, 'LogMyGame'), t ', Log, All);',
          i(0),
        }),

        -- DEFINE_LOG_CATEGORY (usually in MyGame.cpp)
        s('ulogdef', {
          t 'DEFINE_LOG_CATEGORY(', i(1, 'LogMyGame'), t ');',
          i(0),
        }),

      })
    end,
  },
}
