
###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################

create_clock -name MgtRefClk -period 5.000 [get_ports {MgtRefClk_p[0]}]
create_clock -name DeviceClk -period 5.000 [get_ports {DeviceClk_p}]


#########################
## Start instance %ClipInstancePath%/CommonFixedLogicx
#########################

set CommonFixedLogic0 [current_instance .]
current_instance %ClipInstancePath%/CommonFixedLogicx
  
  #########################
  ## Start include, file CommonFixedLogic.xml
  #########################
  
      set BasePath AxiClkRSD
      
      #########################
      ## Start include, file ResetSyncDeassert.xml
      #########################
      
            set ResetSyncDeassertPath $BasePath
            set BasePath $BasePath/DoubleSyncBoolAsyncInx
            
            #########################
            ## Start include, file DoubleSyncBoolAsyncIn.xml
            #########################
            
                    set DoubleSyncBoolAsyncInPath $BasePath
                    set BasePath $BasePath/DoubleSyncSlAsyncInx
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    set BasePath $DoubleSyncBoolAsyncInPath
                    
            
            
            #########################
            ## End include, file DoubleSyncBoolAsyncIn.xml
            #########################
            
            
            # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
            # be treated as fully-asynchronous. This will certainly be the case if the signal is
            # coming from a pin. But even if it's coming from an internal FF, it is never useful
            # to treat is as synchronous. If the signal were synchronous to the output clock, we
            # would have no need for the ResetSyncDeassert in the first place. So it's safe to
            # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
            # true), and avoid the potential for spurious Reset Recovery analysis on that path.
            
            
            set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
            set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
            set_false_path -to $TNM_oSigs -through $TNM_Prst
            
            set BasePath $ResetSyncDeassertPath
            
      
      
      #########################
      ## End include, file ResetSyncDeassert.xml
      #########################
      
      
      #########################
      ## Start instance ConfigGpiox
      #########################
      
      set CommonFixedLogic2 [current_instance .]
      current_instance ConfigGpiox
            
            #########################
            ## Start include, file ConfigGpio.xml
            #########################
            
                    set BasePath ConfigInterruptFilter
                    
                    #########################
                    ## Start include, file FilterStdLogic.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncSlAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                                          set DoubleSyncSlAsyncInPath $BasePath
                                          set BasePath $BasePath/DoubleSyncAsyncInBasex
                                          
                                          #########################
                                          ## Start add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          # ---------------------------------------------------------------------------------------
                                          # DoubleSyncAsyncInBase
                                          # ---------------------------------------------------------------------------------------
                                          # Save incoming path
                                          set DoubleSyncAsyncInBasePath $BasePath
                                          
                                          # First create the groups that will be needed in the -from/to constraints
                                          set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                          set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                          # False path coming in through the D pin.
                                          set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                          # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                          # settle out.
                                          set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                          
                                          
                                          
                                          #########################
                                          ## End add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          set BasePath $DoubleSyncSlAsyncInPath
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file FilterStdLogic.xml
                    #########################
                    
                    
            
            
            #########################
            ## End include, file ConfigGpio.xml
            #########################
            
            
      current_instance -quiet
      current_instance $CommonFixedLogic2
      
      #########################
      ## End instance ConfigGpiox
      #########################
      
      
      #########################
      ## Start instance TimingEnginex
      #########################
      
      set CommonFixedLogic2 [current_instance .]
      current_instance TimingEnginex
            
            #########################
            ## Start include, file TimingEngine.xml
            #########################
            
                    set BasePath ClkEnableDS
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    set BasePath GenTxClocks.TxPllLockedDS
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    set BasePath GenRxClocks.RxPllLockedDS
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    set BasePath GenTxClocks.TxBufResetDS
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    set BasePath GenRxClocks.RxBufResetDS
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    
                    # Ignore timing on the enable of the safebufgce
                    set_false_path -from [get_cells bClkOutEn_reg] -to [get_cells -hierarchical SafeBUFGCTRLx]
                    
                    
            
            
            #########################
            ## End include, file TimingEngine.xml
            #########################
            
            
      current_instance -quiet
      current_instance $CommonFixedLogic2
      
      #########################
      ## End instance TimingEnginex
      #########################
      
      
      #########################
      ## Start instance Jesd204bWrapperx
      #########################
      
      set CommonFixedLogic2 [current_instance .]
      current_instance Jesd204bWrapperx
            
            #########################
            ## Start include, file Jesd204bWrapper.xml
            #########################
            
                    set BasePath StableClkRSD
                    
                    #########################
                    ## Start include, file ResetSyncDeassert.xml
                    #########################
                    
                              set ResetSyncDeassertPath $BasePath
                              set BasePath $BasePath/DoubleSyncBoolAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                                          set DoubleSyncBoolAsyncInPath $BasePath
                                          set BasePath $BasePath/DoubleSyncSlAsyncInx
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                                        set DoubleSyncSlAsyncInPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlAsyncInPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                          set BasePath $DoubleSyncBoolAsyncInPath
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                              
                              # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
                              # be treated as fully-asynchronous. This will certainly be the case if the signal is
                              # coming from a pin. But even if it's coming from an internal FF, it is never useful
                              # to treat is as synchronous. If the signal were synchronous to the output clock, we
                              # would have no need for the ResetSyncDeassert in the first place. So it's safe to
                              # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
                              # true), and avoid the potential for spurious Reset Recovery analysis on that path.
                              
                              
                              set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
                              set_false_path -to $TNM_oSigs -through $TNM_Prst
                              
                              set BasePath $ResetSyncDeassertPath
                              
                    
                    
                    #########################
                    ## End include, file ResetSyncDeassert.xml
                    #########################
                    
                    set BasePath DataClkRSD
                    
                    #########################
                    ## Start include, file ResetSyncDeassert.xml
                    #########################
                    
                              set ResetSyncDeassertPath $BasePath
                              set BasePath $BasePath/DoubleSyncBoolAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                                          set DoubleSyncBoolAsyncInPath $BasePath
                                          set BasePath $BasePath/DoubleSyncSlAsyncInx
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                                        set DoubleSyncSlAsyncInPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlAsyncInPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                          set BasePath $DoubleSyncBoolAsyncInPath
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                              
                              # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
                              # be treated as fully-asynchronous. This will certainly be the case if the signal is
                              # coming from a pin. But even if it's coming from an internal FF, it is never useful
                              # to treat is as synchronous. If the signal were synchronous to the output clock, we
                              # would have no need for the ResetSyncDeassert in the first place. So it's safe to
                              # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
                              # true), and avoid the potential for spurious Reset Recovery analysis on that path.
                              
                              
                              set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
                              set_false_path -to $TNM_oSigs -through $TNM_Prst
                              
                              set BasePath $ResetSyncDeassertPath
                              
                    
                    
                    #########################
                    ## End include, file ResetSyncDeassert.xml
                    #########################
                    
                    set BasePath InstantiateRx.RxUserClk2RSD
                    
                    #########################
                    ## Start include, file ResetSyncDeassert.xml
                    #########################
                    
                              set ResetSyncDeassertPath $BasePath
                              set BasePath $BasePath/DoubleSyncBoolAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                                          set DoubleSyncBoolAsyncInPath $BasePath
                                          set BasePath $BasePath/DoubleSyncSlAsyncInx
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                                        set DoubleSyncSlAsyncInPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlAsyncInPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                          set BasePath $DoubleSyncBoolAsyncInPath
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                              
                              # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
                              # be treated as fully-asynchronous. This will certainly be the case if the signal is
                              # coming from a pin. But even if it's coming from an internal FF, it is never useful
                              # to treat is as synchronous. If the signal were synchronous to the output clock, we
                              # would have no need for the ResetSyncDeassert in the first place. So it's safe to
                              # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
                              # true), and avoid the potential for spurious Reset Recovery analysis on that path.
                              
                              
                              set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
                              set_false_path -to $TNM_oSigs -through $TNM_Prst
                              
                              set BasePath $ResetSyncDeassertPath
                              
                    
                    
                    #########################
                    ## End include, file ResetSyncDeassert.xml
                    #########################
                    
                    set BasePath InstantiateTx.TxUserClk2RSD
                    
                    #########################
                    ## Start include, file ResetSyncDeassert.xml
                    #########################
                    
                              set ResetSyncDeassertPath $BasePath
                              set BasePath $BasePath/DoubleSyncBoolAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                                          set DoubleSyncBoolAsyncInPath $BasePath
                                          set BasePath $BasePath/DoubleSyncSlAsyncInx
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                                        set DoubleSyncSlAsyncInPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlAsyncInPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                          set BasePath $DoubleSyncBoolAsyncInPath
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                              
                              # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
                              # be treated as fully-asynchronous. This will certainly be the case if the signal is
                              # coming from a pin. But even if it's coming from an internal FF, it is never useful
                              # to treat is as synchronous. If the signal were synchronous to the output clock, we
                              # would have no need for the ResetSyncDeassert in the first place. So it's safe to
                              # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
                              # true), and avoid the potential for spurious Reset Recovery analysis on that path.
                              
                              
                              set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
                              set_false_path -to $TNM_oSigs -through $TNM_Prst
                              
                              set BasePath $ResetSyncDeassertPath
                              
                    
                    
                    #########################
                    ## End include, file ResetSyncDeassert.xml
                    #########################
                    
                    set BasePath InstantiateTx.DacSyncDS
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set DoubleSyncSlAsyncInPath $BasePath
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # ---------------------------------------------------------------------------------------
                              # DoubleSyncAsyncInBase
                              # ---------------------------------------------------------------------------------------
                              # Save incoming path
                              set DoubleSyncAsyncInBasePath $BasePath
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              set BasePath $DoubleSyncSlAsyncInPath
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    
                    #########################
                    ## Start instance InstantiateRx.RxJesd204bRegsx
                    #########################
                    
                    set CommonFixedLogic4 [current_instance .]
                    current_instance InstantiateRx.RxJesd204bRegsx
                              
                              #########################
                              ## Start include, file RxJesd204bRegs.xml
                              #########################
                              
                                          set BasePath ClearRxLmfcDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath StartCodeGroupSyncPS/PulseSyncBasex
                                          
                                          #########################
                                          ## Start include, file PulseSyncBase.xml
                                          #########################
                                          
                                                        set PulseSyncBasePath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $PulseSyncBasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $PulseSyncBasePath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file PulseSyncBase.xml
                                          #########################
                                          
                                          set BasePath BypassDescramblerDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath SkipCharReplacementDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath GtResetsDoneDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath GtChanBondingDoneDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath CodeGrpSyncDoneDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath CodeGrpSyncRequestDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LinkErrorStickyDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LinkDispErrorStickyDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LinkNotInTableErrorStickyDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LinkMisAlignmentErrorStickyDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath AdcCodeGrpSyncRequestStickyDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath UnExpectedKCharErrorStickyDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath DbgElasticBufSlackHS
                                          
                                          #########################
                                          ## Start include, file HandshakeSLV_RSD.xml
                                          #########################
                                          
                                                        set HandshakeSlvRsdPath $BasePath
                                                        set BasePath $BasePath/HBx
                                                        
                                                        #########################
                                                        ## Start add from file HandshakeBaseRSD.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # HandshakeBaseRSD
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set HandshakeBaseRsdPath $BasePath
                                                        
                                                        # Data
                                                        set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
                                                        # Toggle
                                                        set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
                                                        # Ready
                                                        set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        # Find out the minimum period of the clocks related to the previous groups.
                                                        set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
                                                        
                                                        # The datapath clock crossings must be less than 2X the period of the destination clock.
                                                        set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]
                                                        
                                                        # Toggle
                                                        set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
                                                        set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        # The return ready path isn't very important here.
                                                        set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
                                                        set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file HandshakeBaseRSD.xdc
                                                        #########################
                                                        
                                                        set BasePath $HandshakeSlvRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file HandshakeSLV_RSD.xml
                                          #########################
                                          
                                          set BasePath RxInterleavingModeDS0
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath RxInterleavingModeDS1
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file RxJesd204bRegs.xml
                              #########################
                              
                              
                    current_instance -quiet
                    current_instance $CommonFixedLogic4
                    
                    #########################
                    ## End instance InstantiateRx.RxJesd204bRegsx
                    #########################
                    
                    
                    #########################
                    ## Start instance InstantiateTx.TxJesd204bRegsx
                    #########################
                    
                    set CommonFixedLogic4 [current_instance .]
                    current_instance InstantiateTx.TxJesd204bRegsx
                              
                              #########################
                              ## Start include, file TxJesd204bRegs.xml
                              #########################
                              
                                          set BasePath GtResetsDoneDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath JesdCharReplEnDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                                        set DoubleSyncBoolRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncBoolRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                          set BasePath JesdScramblerEnDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                                        set DoubleSyncBoolRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncBoolRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                          set BasePath TxFifoResetDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                                        set DoubleSyncBoolRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncBoolRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                          set BasePath RunTransmitDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                                        set DoubleSyncBoolRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncBoolRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                          set BasePath SyncFromSwDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                                        set DoubleSyncBoolRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncBoolRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncBoolRSD.xml
                                          #########################
                                          
                                          set BasePath TransmitIdleDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LaneSyncReqDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LanesSyncedDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath LanesAlignedDS
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                                        set DoubleSyncSlRsdPath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $DoubleSyncSlRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSL_RSD.xml
                                          #########################
                                          
                                          set BasePath DbgFrameEngineStateHS
                                          
                                          #########################
                                          ## Start include, file HandshakeSLV_RSD.xml
                                          #########################
                                          
                                                        set HandshakeSlvRsdPath $BasePath
                                                        set BasePath $BasePath/HBx
                                                        
                                                        #########################
                                                        ## Start add from file HandshakeBaseRSD.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # HandshakeBaseRSD
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set HandshakeBaseRsdPath $BasePath
                                                        
                                                        # Data
                                                        set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
                                                        # Toggle
                                                        set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
                                                        # Ready
                                                        set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        # Find out the minimum period of the clocks related to the previous groups.
                                                        set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
                                                        
                                                        # The datapath clock crossings must be less than 2X the period of the destination clock.
                                                        set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]
                                                        
                                                        # Toggle
                                                        set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
                                                        set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        # The return ready path isn't very important here.
                                                        set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
                                                        set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file HandshakeBaseRSD.xdc
                                                        #########################
                                                        
                                                        set BasePath $HandshakeSlvRsdPath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file HandshakeSLV_RSD.xml
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file TxJesd204bRegs.xml
                              #########################
                              
                              
                    current_instance -quiet
                    current_instance $CommonFixedLogic4
                    
                    #########################
                    ## End instance InstantiateTx.TxJesd204bRegsx
                    #########################
                    
                    
                    #########################
                    ## Start instance InstantiateTx.TxRateConverter
                    #########################
                    
                    set CommonFixedLogic4 [current_instance .]
                    current_instance InstantiateTx.TxRateConverter
                              
                              #########################
                              ## Start include, file TxRateConverterFifo.xml
                              #########################
                              
                                          set BasePath "PulseSyncBoolStatRSDx/PulseSyncBasex"
                                          
                                          #########################
                                          ## Start include, file PulseSyncBase.xml
                                          #########################
                                          
                                                        set PulseSyncBasePath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $PulseSyncBasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $PulseSyncBasePath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file PulseSyncBase.xml
                                          #########################
                                          
                                          set BasePath "Fifos[0].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[1].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[2].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[3].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file TxRateConverterFifo.xml
                              #########################
                              
                              
                    current_instance -quiet
                    current_instance $CommonFixedLogic4
                    
                    #########################
                    ## End instance InstantiateTx.TxRateConverter
                    #########################
                    
                    
                    #########################
                    ## Start instance InstantiateRx.Jesd204bReceiverx/RateConverterElasticBufferx/RateConversionFifo
                    #########################
                    
                    set CommonFixedLogic4 [current_instance .]
                    current_instance InstantiateRx.Jesd204bReceiverx/RateConverterElasticBufferx/RateConversionFifo
                              
                              #########################
                              ## Start include, file RxRateConverterFifo.xml
                              #########################
                              
                                          set BasePath "PulseSyncBoolStatRSDx/PulseSyncBasex"
                                          
                                          #########################
                                          ## Start include, file PulseSyncBase.xml
                                          #########################
                                          
                                                        set PulseSyncBasePath $BasePath
                                                        set BasePath $BasePath/DoubleSyncBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save Incoming path
                                                        set DoubleSyncBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $PulseSyncBasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # ---------------------------------------------------------------------------------------
                                                        # DoubleSyncAsyncInBase
                                                        # ---------------------------------------------------------------------------------------
                                                        # Save incoming path
                                                        set DoubleSyncAsyncInBasePath $BasePath
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        set BasePath $PulseSyncBasePath
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file PulseSyncBase.xml
                                          #########################
                                          
                                          set BasePath "Fifos[0].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[1].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[2].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[3].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          set BasePath "Fifos[4].LutRamFifoRSDx"
                                          
                                          #########################
                                          ## Start add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          #vreview_group JackalopeXdc
                                          #vreview_closed http://review-board.natinst.com/r/254910/
                                          #vreview_reviewers kygreen dhearn rortega privera lboughal
                                          
                                          #First create the groups that will be needed in the -from/to constraints
                                          set TNM_FifoRsd_iWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oWrGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray_ms    [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/*/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_iRdGray       [get_cells "$BasePath/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/*/*"    -filter {IS_SEQUENTIAL==true}]
                                          set TNM_FifoRsd_oDataFlop     [get_cells "$BasePath/DualPortLutRamx/oDataOutLoc_reg*" -filter {IS_SEQUENTIAL==true}]
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_iWrGray]] ,])"]
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_FifoRsd_oWrGray_ms]] ,])"]
                                          #Third, create constraints as a function of those clocks
                                          set_max_delay  -from $TNM_FifoRsd_iWrGray       -to $TNM_FifoRsd_oWrGray_ms -datapath_only [expr   1 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oWrGray_ms    -to $TNM_FifoRsd_oWrGray    -datapath_only [expr 0.5 * $T_OClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_oRdGray       -to $TNM_FifoRsd_iRdGray_ms -datapath_only [expr   1 * $T_IClkMin]
                                          set_max_delay  -from $TNM_FifoRsd_iRdGray_ms    -to $TNM_FifoRsd_iRdGray    -datapath_only [expr 0.5 * $T_IClkMin]
                                          set_false_path -from [get_clocks -of $TNM_FifoRsd_iWrGray] -to $TNM_FifoRsd_oDataFlop
                                          
                                          
                                          
                                          #########################
                                          ## End add from file LutRamFifoRSD.xdc
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file RxRateConverterFifo.xml
                              #########################
                              
                              
                    current_instance -quiet
                    current_instance $CommonFixedLogic4
                    
                    #########################
                    ## End instance InstantiateRx.Jesd204bReceiverx/RateConverterElasticBufferx/RateConversionFifo
                    #########################
                    
                    
            
            
            #########################
            ## End include, file Jesd204bWrapper.xml
            #########################
            
            
      current_instance -quiet
      current_instance $CommonFixedLogic2
      
      #########################
      ## End instance Jesd204bWrapperx
      #########################
      
      
  
  
  #########################
  ## End include, file CommonFixedLogic.xml
  #########################
  
  
  #########################
  ## Start instance Jesd204bWrapperx/PhyLayer/gtwizard_ultrascale_0x
  #########################
  
  set CommonFixedLogic1 [current_instance .]
  current_instance Jesd204bWrapperx/PhyLayer/gtwizard_ultrascale_0x
      
      #########################
      ## Start add from file gtwizard_ultrascale_0.xdc
      #########################
      
      #------------------------------------------------------------------------------
      #  (c) Copyright 2013-2015 Xilinx, Inc. All rights reserved.
      #
      #  This file contains confidential and proprietary information
      #  of Xilinx, Inc. and is protected under U.S. and
      #  international copyright and other intellectual property
      #  laws.
      #
      #  DISCLAIMER
      #  This disclaimer is not a license and does not grant any
      #  rights to the materials distributed herewith. Except as
      #  otherwise provided in a valid license issued to you by
      #  Xilinx, and to the maximum extent permitted by applicable
      #  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
      #  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
      #  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
      #  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
      #  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
      #  (2) Xilinx shall not be liable (whether in contract or tort,
      #  including negligence, or under any other theory of
      #  liability) for any loss or damage of any kind or nature
      #  related to, arising under or in connection with these
      #  materials, including for any direct, or any indirect,
      #  special, incidental, or consequential loss or damage
      #  (including loss of data, profits, goodwill, or any type of
      #  loss or damage suffered as a result of any action brought
      #  by a third party) even if such damage or loss was
      #  reasonably foreseeable or Xilinx had been advised of the
      #  possibility of the same.
      #
      #  CRITICAL APPLICATIONS
      #  Xilinx products are not designed or intended to be fail-
      #  safe, or for use in any application requiring fail-safe
      #  performance, such as life-support or safety devices or
      #  systems, Class III medical devices, nuclear facilities,
      #  applications related to the deployment of airbags, or any
      #  other applications that could lead to death, personal
      #  injury, or severe property or environmental damage
      #  (individually and collectively, "Critical
      #  Applications"). Customer assumes the sole risk and
      #  liability of any use of Xilinx products in Critical
      #  Applications, subject only to applicable laws and
      #  regulations governing limitations on product liability.
      #
      #  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
      #  PART OF THIS FILE AT ALL TIMES.
      #------------------------------------------------------------------------------
      
      
      # UltraScale FPGAs Transceivers Wizard IP core-level XDC file
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y8
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y8 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[26].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin Y1 [get_ports gthrxn_in[0]]
      #set_property package_pin Y2 [get_ports gthrxp_in[0]]
      #set_property package_pin AA3 [get_ports gthtxn_out[0]]
      #set_property package_pin AA4 [get_ports gthtxp_out[0]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y9
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y9 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[26].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin V1 [get_ports gthrxn_in[1]]
      #set_property package_pin V2 [get_ports gthrxp_in[1]]
      #set_property package_pin W3 [get_ports gthtxn_out[1]]
      #set_property package_pin W4 [get_ports gthtxp_out[1]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y10
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y10 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[26].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin T1 [get_ports gthrxn_in[2]]
      #set_property package_pin T2 [get_ports gthrxp_in[2]]
      #set_property package_pin U3 [get_ports gthtxn_out[2]]
      #set_property package_pin U4 [get_ports gthtxp_out[2]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y11
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y11 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[26].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin P1 [get_ports gthrxn_in[3]]
      #set_property package_pin P2 [get_ports gthrxp_in[3]]
      #set_property package_pin R3 [get_ports gthtxn_out[3]]
      #set_property package_pin R4 [get_ports gthtxp_out[3]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y12
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y12 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin M1 [get_ports gthrxn_in[4]]
      #set_property package_pin M2 [get_ports gthrxp_in[4]]
      #set_property package_pin N3 [get_ports gthtxn_out[4]]
      #set_property package_pin N4 [get_ports gthtxp_out[4]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y13
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y13 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin K1 [get_ports gthrxn_in[5]]
      #set_property package_pin K2 [get_ports gthrxp_in[5]]
      #set_property package_pin L3 [get_ports gthtxn_out[5]]
      #set_property package_pin L4 [get_ports gthtxp_out[5]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y14
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y14 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin H1 [get_ports gthrxn_in[6]]
      #set_property package_pin H2 [get_ports gthrxp_in[6]]
      #set_property package_pin J3 [get_ports gthtxn_out[6]]
      #set_property package_pin J4 [get_ports gthtxp_out[6]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y15
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y15 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin F1 [get_ports gthrxn_in[7]]
      #set_property package_pin F2 [get_ports gthrxp_in[7]]
      #set_property package_pin G3 [get_ports gthtxn_out[7]]
      #set_property package_pin G4 [get_ports gthtxp_out[7]]
      
      
      # False path constraints
      # ----------------------------------------------------------------------------------------------------------------------
      
      set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
      
      ##set_false_path -to [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_*_reg}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_meta_reg/D}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_meta_reg/PRE}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync1_reg/PRE}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync2_reg/PRE}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync3_reg/PRE}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_out_reg/PRE}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_meta_reg/CLR}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync1_reg/CLR}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync2_reg/CLR}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync3_reg/CLR}]
      set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_out_reg/CLR}]
      
      
      
      
      #########################
      ## End add from file gtwizard_ultrascale_0.xdc
      #########################
      
      
  current_instance -quiet
  current_instance $CommonFixedLogic1
  
  #########################
  ## End instance Jesd204bWrapperx/PhyLayer/gtwizard_ultrascale_0x
  #########################
  
  
current_instance -quiet
current_instance $CommonFixedLogic0

#########################
## End instance %ClipInstancePath%/CommonFixedLogicx
#########################


#########################
## Start add from file IoTiming.xdc
#########################

#vreview_group JackalopeXdc
#vreview_closed http://review-board.natinst.com/r/254910/
#vreview_reviewers kygreen dhearn rortega privera lboughal

# --------------------------
# Sysref Timing Constraints
# --------------------------
#                                  ______
#  _____________                  |      |         ___________          ____________
# |             |                 |      |        |           |        |            |
# |             |---{DeviceClk}---|      |--------|  SY89833  |--------|            |
# |    LMK      |                 | B2B  |        |___________|        |    FPGA    |
# |             |                 |      |                             |            |
# |             |----{sysref}-----|      |-----------------------------|            |
# |_____________|                 |      |                             |____________|
#                                 |______|
#
# Based on LMK04828 data we got from TI, the skew can easily be in the +/-150
# ps range between the signals coming out of the IC. Set sysref skew to 200 ps
# to be conservative

# time constant of ps/in trace delay
set k_pd_max 0.190
set k_pd_min 0.150
set k_Tvco   0.3125

# Min and max time delays through system
set sysref_skew_min    -0.200
set sysref_skew_max     0.200
set sysref_prog_dly    [expr (10 + 10 + 2) * $k_Tvco]
set sysref_to_b2b_max  [expr $k_pd_max * 1.5503]
set sysref_to_b2b_min  [expr $k_pd_min * 1.5503]
set sysref_to_fpga_max $dtJesd204SysRef_Tpd_Max
set sysref_to_fpga_min $dtJesd204SysRef_Tpd_Min
set dataclk_prog_dly    [expr 8 * $k_Tvco]
set dataclk_to_b2b_max [expr $k_pd_max * 1.5508]
set dataclk_to_b2b_min [expr $k_pd_min * 1.5508]
# Propagation delay from B2B connector, through SY8933 buffer, to the FPGA
set dataclk_thru_buf_max $DataClk_Tpd_Max
set dataclk_thru_buf_min $DataClk_Tpd_Min

set sysref_max_delay [expr $sysref_prog_dly + $sysref_skew_max + $sysref_to_b2b_max + $sysref_to_fpga_max \
- $dataclk_prog_dly - $dataclk_to_b2b_min - $dataclk_thru_buf_min]
set sysref_min_delay [expr $sysref_prog_dly + $sysref_skew_min + $sysref_to_b2b_min + $sysref_to_fpga_min \
- $dataclk_prog_dly - $dataclk_to_b2b_max - $dataclk_thru_buf_max]

set_input_delay -clock DeviceClk -max $sysref_max_delay [get_ports {dvJesd204SysRef_p dvJesd204SysRef_n}]
set_input_delay -clock DeviceClk -min $sysref_min_delay [get_ports {dvJesd204SysRef_p dvJesd204SysRef_n}]


#########################
## End add from file IoTiming.xdc
#########################


