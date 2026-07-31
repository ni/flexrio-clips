
###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################

create_clock -name MgtRefClk -period 5.000 [get_ports {MgtRefClk_p[0]}]
create_clock -name DeviceClk -period 5.000 [get_ports {DeviceClk_p}]

# Find the Clocks coming out of the CLIP MMCM/PLL
set ClipMmcmClkOut0 [get_pins %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT0]
set ClipMmcmClkOut1 [get_pins %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT1]
set ClipPllClkOut0  [get_pins %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/PLLE3_BASEx/CLKOUT0]

# Create generated clock with readable names
create_generated_clock -name DataClk2x     [get_pins $ClipMmcmClkOut0]
create_generated_clock -name DataClk       [get_pins $ClipMmcmClkOut1]
create_generated_clock -name UsrClkRx      [get_pins $ClipPllClkOut0]
create_generated_clock -name GtUsrClk2Rx   [get_pins {%ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/GtUsrClk2RxBuf/O}]

# Minimize Skew between related MMCM DataClks
set_property CLOCK_DELAY_GROUP DataClkMmcmBufgs [get_nets -of_objects [get_pin %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/DataClkSafeBufgce/SafeBUFGCTRLx/O]]
set_property CLOCK_DELAY_GROUP DataClkMmcmBufgs [get_nets -of_objects [get_pin %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/DataClk2xSafeBufgce/SafeBUFGCTRLx/O]]

# Place the GtUsrClkRxBuf/GtUsrClk2RxBuf CLOCK_ROOT on the same clock region as the GT reference clock to minimize Skew
set_property USER_CLOCK_ROOT [get_clock_regions -of_objects [get_cells %ClipInstancePath%/GtRefClkBuf]] \
[get_nets -of [get_pins %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/GtUsrClk2RxBuf/O]]

set_property USER_CLOCK_ROOT [get_clock_regions -of_objects [get_cells %ClipInstancePath%/GtRefClkBuf]] \
[get_nets -of [get_pins %ClipInstancePath%/NI5774FixedLogicx/TimingEnginex/GtUsrClkRxBuf/O]]



#########################
## Start instance %ClipInstancePath%/NI5774FixedLogicx
#########################

set NI5774FixedLogic0 [current_instance .]
current_instance %ClipInstancePath%/NI5774FixedLogicx
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
  
  
  #########################
  ## Start instance ConfigGpiox
  #########################
  
  set NI5774FixedLogic1 [current_instance .]
  current_instance ConfigGpiox
      
      #########################
      ## Start include, file ConfigGpio.xml
      #########################
      
            set BasePath TdcExpandedPulseDs
            
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
            
            set BasePath FilterStdLogicx
            
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
  current_instance $NI5774FixedLogic1
  
  #########################
  ## End instance ConfigGpiox
  #########################
  
  
  #########################
  ## Start instance TimingEnginex
  #########################
  
  set NI5774FixedLogic1 [current_instance .]
  current_instance TimingEnginex
      
      #########################
      ## Start include, file TimingEngine.xml
      #########################
      
            set BasePath MmcmLockFilter
            
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
            
            set BasePath PllLockFilter
            
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
            
            set BasePath SyncClkEn
            
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
  current_instance $NI5774FixedLogic1
  
  #########################
  ## End instance TimingEnginex
  #########################
  
  
  #########################
  ## Start instance Jesd204bWrapperx
  #########################
  
  set NI5774FixedLogic1 [current_instance .]
  current_instance Jesd204bWrapperx
      
      #########################
      ## Start include, file Jesd204bWrapper.xml
      #########################
      
            set BasePath ReliableClkRSD
            
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
            
            set BasePath UserClkRSD
            
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
            
            
            #########################
            ## Start instance Jesd204bAxiRegsx
            #########################
            
            set NI5774FixedLogic3 [current_instance .]
            current_instance Jesd204bAxiRegsx
                    
                    #########################
                    ## Start include, file Jesd204bAxiRegsx.xml
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
                              
                              set BasePath StartCodeGroupSyncPulseSync/PulseSyncBasex
                              
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
                              
                              set BasePath ResetLmfcPulseSync/PulseSyncBasex
                              
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
                              
                              set BasePath SysrefCaptureEnDS
                              
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
                              
                              set BasePath GtRxChanBondingDoneDS
                              
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
                              
                              set BasePath GtRxResetsDoneDS
                              
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
                              
                              
                    
                    
                    #########################
                    ## End include, file Jesd204bAxiRegsx.xml
                    #########################
                    
                    
            current_instance -quiet
            current_instance $NI5774FixedLogic3
            
            #########################
            ## End instance Jesd204bAxiRegsx
            #########################
            
            
            #########################
            ## Start instance Jesd204bTopx/RateConverterElasticBufferx/RateConversionFifo
            #########################
            
            set NI5774FixedLogic3 [current_instance .]
            current_instance Jesd204bTopx/RateConverterElasticBufferx/RateConversionFifo
                    
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
                              
                              #vreview_group SphinxXdc
                              #vreview_closed http://review-board.natinst.com/r/264925/
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
                              
                              #vreview_group SphinxXdc
                              #vreview_closed http://review-board.natinst.com/r/264925/
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
                              
                              #vreview_group SphinxXdc
                              #vreview_closed http://review-board.natinst.com/r/264925/
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
                              
                              #vreview_group SphinxXdc
                              #vreview_closed http://review-board.natinst.com/r/264925/
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
                              
                              #vreview_group SphinxXdc
                              #vreview_closed http://review-board.natinst.com/r/264925/
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
            current_instance $NI5774FixedLogic3
            
            #########################
            ## End instance Jesd204bTopx/RateConverterElasticBufferx/RateConversionFifo
            #########################
            
            
      
      
      #########################
      ## End include, file Jesd204bWrapper.xml
      #########################
      
      
  current_instance -quiet
  current_instance $NI5774FixedLogic1
  
  #########################
  ## End instance Jesd204bWrapperx
  #########################
  
  
  #########################
  ## Start instance Jesd204bWrapperx/Jesd204bTopx/GtWizWrapperx/gtwizard_ultrascale_0x
  #########################
  
  set NI5774FixedLogic1 [current_instance .]
  current_instance Jesd204bWrapperx/Jesd204bTopx/GtWizWrapperx/gtwizard_ultrascale_0x
      
      #########################
      ## Start add from file gtwizard_ultrascale_0_ooc.xdc
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
      
      
      # UltraScale FPGAs Transceivers Wizard IP core-level XDC file for out-of-context flows
      # ----------------------------------------------------------------------------------------------------------------------
      
      # This constraints file contains default clock frequencies to be used during out-of-context flows such as
      # OOC Synthesis and Hierarchical Designs.
      
      # Free-running clock constraint
      #create_clock -period 6.25 [get_ports gtwiz_reset_clk_freerun_in]
      
      # QPLL0 reference clock constraint (will be overridden by required constraint on IBUFDS_GTE3 input in context)
      #create_clock -period 5.0 [get_ports gtrefclk00_in[0]]
      #create_clock -period 5.0 [get_ports gtrefclk00_in[1]]
      
      # Internal TX user clock constraint (will be overridden by required reference clock constraint propagated through CHANNEL primitive in context)
      #create_clock -period 3.125 [get_ports txusrclk_in[0]]
      #create_clock -period 3.125 [get_ports txusrclk_in[1]]
      #create_clock -period 3.125 [get_ports txusrclk_in[2]]
      #create_clock -period 3.125 [get_ports txusrclk_in[3]]
      #create_clock -period 3.125 [get_ports txusrclk_in[4]]
      #create_clock -period 3.125 [get_ports txusrclk_in[5]]
      #create_clock -period 3.125 [get_ports txusrclk_in[6]]
      #create_clock -period 3.125 [get_ports txusrclk_in[7]]
      
      # External TX user clock constraint (will be overridden by required reference clock constraint propagated through CHANNEL primitive in context)
      #create_clock -period 6.25 [get_ports txusrclk2_in[0]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[1]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[2]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[3]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[4]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[5]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[6]]
      #create_clock -period 6.25 [get_ports txusrclk2_in[7]]
      
      # Internal RX user clock constraint (will be overridden by required reference clock constraint propagated through CHANNEL primitive in context)
      #create_clock -period 3.125 [get_ports rxusrclk_in[0]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[1]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[2]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[3]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[4]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[5]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[6]]
      #create_clock -period 3.125 [get_ports rxusrclk_in[7]]
      
      # External RX user clock constraint (will be overridden by required reference clock constraint propagated through CHANNEL primitive in context)
      #create_clock -period 6.25 [get_ports rxusrclk2_in[0]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[1]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[2]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[3]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[4]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[5]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[6]]
      #create_clock -period 6.25 [get_ports rxusrclk2_in[7]]
      
      # DRP clock constraint for CHANNEL primitive
      #create_clock -period 6.25 [get_ports drpclk_in[0]]
      #create_clock -period 6.25 [get_ports drpclk_in[1]]
      #create_clock -period 6.25 [get_ports drpclk_in[2]]
      #create_clock -period 6.25 [get_ports drpclk_in[3]]
      #create_clock -period 6.25 [get_ports drpclk_in[4]]
      #create_clock -period 6.25 [get_ports drpclk_in[5]]
      #create_clock -period 6.25 [get_ports drpclk_in[6]]
      #create_clock -period 6.25 [get_ports drpclk_in[7]]
      
      # DRP clock constraint for COMMON primitive
      #create_clock -period 6.25 [get_ports drpclk_common_in[0]]
      #create_clock -period 6.25 [get_ports drpclk_common_in[1]]
      
      # Common reference clock 10 constraint
      #create_clock -period 5.0 [get_ports gtrefclk10_in[0]]
      #create_clock -period 5.0 [get_ports gtrefclk10_in[1]]
      
      # Common north reference clock 00 constraint
      #create_clock -period 5.0 [get_ports gtnorthrefclk00_in[0]]
      #create_clock -period 5.0 [get_ports gtnorthrefclk00_in[1]]
      
      # Common north reference clock 10 constraint
      #create_clock -period 5.0 [get_ports gtnorthrefclk10_in[0]]
      #create_clock -period 5.0 [get_ports gtnorthrefclk10_in[1]]
      
      # Common south reference clock 00 constraint
      #create_clock -period 5.0 [get_ports gtsouthrefclk00_in[0]]
      #create_clock -period 5.0 [get_ports gtsouthrefclk00_in[1]]
      
      # Common south reference clock 10 constraint
      #create_clock -period 5.0 [get_ports gtsouthrefclk10_in[0]]
      #create_clock -period 5.0 [get_ports gtsouthrefclk10_in[1]]
      
      # QPLL0 lock detection clock constraint for COMMON primitive
      #create_clock -period 6.25 [get_ports qpll0lockdetclk_in[0]]
      #create_clock -period 6.25 [get_ports qpll0lockdetclk_in[1]]
      
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
      ## End add from file gtwizard_ultrascale_0_ooc.xdc
      #########################
      
      
  current_instance -quiet
  current_instance $NI5774FixedLogic1
  
  #########################
  ## End instance Jesd204bWrapperx/Jesd204bTopx/GtWizWrapperx/gtwizard_ultrascale_0x
  #########################
  
  
current_instance -quiet
current_instance $NI5774FixedLogic0

#########################
## End instance %ClipInstancePath%/NI5774FixedLogicx
#########################


#########################
## Start add from file NI5774IoTiming.xdc
#########################

#vreview_group SphinxXdc
#vreview_closed http://review-board.natinst.com/r/264925/
#vreview_reviewers kygreen dhearn rortega privera lboughal

# --------------------------
# Sysref Timing Constraints
# --------------------------
#                                  ______
#  _____________                  |      |         ___________          ____________
# |             |                 |      |        |           |        |            |
# |             |---{DeviceClk}---|      |--------|  SY89833  |--------|            |
# |             |                 |      |        |           |        |            |
# |    LMK      |                 | B2B  |        |___________|        |    FPGA    |
# |             |                 |      |                             |            |
# |             |                 |      |                             |            |
# |             |----{sysref}-----|      |-----------------------------|            |
# |_____________|                 |      |                             |____________|
#                                 |______|

# Force aTriggerIn FF on IOB for consistent timing
set_property IOB TRUE [get_ports dvJesd204SysRef*]

# LMK04832 IC Sysref programmed Skew With respect to the Device clock
# The LMK04832 has the capability to delay Sysref with respect to the device clocks in units of VCO cycles (312.5 ps @ 3.2 GHz)
# The following number represents the SYSREF skew (time lag) with respect to the FpgaDeviceClk (6 VCO cycles)
set SysrefToFpgaDeviceClkProgSkew 1.875

# LMK04832 Clock/Sysref package Skew
set FpgaDeviceClkSysrefPackageSkew 0.25

# FpgaDeviceClk/Sysref Sphinx PCB distribution Skew
# As shown below, the FpgaDeviceClk/Sysref skew is very small and hence will be ignored
# FpgaDeviceClk trace length = 1,023 mils on Sphinx
# Sysref trace length        =   968 mils on Sphinx
# minimum Skew = 120 ps/in * (1,023 - 968) = 6.6 ps;
# maximum Skew = 180 ps/in * (1,023 - 968) = 9.9 ps;

# Connector delay is specified to be about 25 ps in its datasheet, but we are ignoring it here
# since the FpgaDataclock and the Sysref go both through the connector in the same direction
# and hence incur about the same delay through the connector.

set SysrefMaxDelay  {$SysrefToFpgaDeviceClkProgSkew +$FpgaDeviceClkSysrefPackageSkew + $dtJesd204SysRef_Tpd_Max -$DataClk_Tpd_Min}
set SysrefMinDelay  {$SysrefToFpgaDeviceClkProgSkew -$FpgaDeviceClkSysrefPackageSkew + $dtJesd204SysRef_Tpd_Min -$DataClk_Tpd_Max}

set_input_delay -clock [get_clocks -of_objects [get_ports DeviceClk_p]] -max [expr $SysrefMaxDelay] [get_ports {dvJesd204SysRef_p dvJesd204SysRef_n}]
set_input_delay -clock [get_clocks -of_objects [get_ports DeviceClk_p]] -min [expr $SysrefMinDelay] [get_ports {dvJesd204SysRef_p dvJesd204SysRef_n}]

# --------------------------
# Input Trigger Constraints
# --------------------------

# Force aTriggerIn FF on IOB for consistent timing
set_property IOB TRUE [get_ports aTriggerIn*]

# LMK04832 IC programmed clock Skew
# The LMK04832 has the capability to delay one clock vs another in units of VCO cycles (312.5 ps @ 3.2 GHz)
# The following number represents the trigger In clock skew (time lag) with respect to the FpgaDeviceClk (2 VCO cycles)
set TrigInClkToFpgaDeviceClkProgSkew 0.625

#  LMK04832 IC package Skew
# The TriggerInClk to FpgaDeviceClk package skew was measured to be smaller than 100 ps
# The FpgaDeviceClk slightly lags the TriggerInClk since the former is LVDS (slower edges)
# and the latter is LVPECL (faster edges).We are going to assume that the skew between these
# two clocks has a maximum of +/-500 ps over PVT, which should be plenty generous.
set TrigInClkFpgaDeviceClkPackageSkew 0.5

# FpgaDeviceClk/TriggerInClk Sphinx PCB distribution Skew
# FpgaDeviceClk trace length = 1,023 mils on Sphinx
# TriggerInClk trace length  = 1,281 mils on Sphinx
# minimum Skew = 120 ps/in * (1,023 - 1,281) = -31 ps; // Ignore, small
# maximum Skew = 180 ps/in * (1,023 - 1,281) = -46 ps; // Ignore, small

# Trigger IN PECL Flop propagation delay
set MC10EP52TpdMin 0.25
set MC10EP52TpdMax 0.41

# SN65LVDS100 Trigger In Propagation Delay
set SN65LVDS100TpdMin 0.3
set SN65LVDS100TpdMax 0.8

# Input Trigger PCB Delay: 2,739 mils on Sphinx
# minimum Delay = 120 ps/in * 2,739  = 416 ps;
# maximum Delay = 180 ps/in * 2,739  = 625 ps;
set TriggerInPcbDlymin 0.42
set TriggerInPcbDlymax 0.63

# Connector delay is specified to be about 25 ps in its datasheet, but we are ignoring it here
# since the FpgaDataclock and the trigger in go both through the connector in the same direction
# and hence incur about the same delay through the connector.

set InputTriggerToFpgaMaxDelay  {$TrigInClkToFpgaDeviceClkProgSkew + $TrigInClkFpgaDeviceClkPackageSkew  + $MC10EP52TpdMax + $SN65LVDS100TpdMax + $TriggerInPcbDlymax  + $aTriggerIn_Tpd_Max -$DataClk_Tpd_Min}
set InputTriggerToFpgaMinDelay  {$TrigInClkToFpgaDeviceClkProgSkew - $TrigInClkFpgaDeviceClkPackageSkew  + $MC10EP52TpdMin + $SN65LVDS100TpdMin + $TriggerInPcbDlymin  + $aTriggerIn_Tpd_Min -$DataClk_Tpd_Max}

set_input_delay -clock [get_clocks -of_objects [get_ports DeviceClk_p]] -max [expr $InputTriggerToFpgaMaxDelay] [get_ports aTriggerIn_p]
set_input_delay -clock [get_clocks -of_objects [get_ports DeviceClk_p]] -min [expr $InputTriggerToFpgaMinDelay] [get_ports aTriggerIn_p]

# --------------------------
# Output Trigger Constraints
# --------------------------

# Force aTriggerOut FF on IOB for consistent timing
set_property IOB TRUE [get_ports aTriggerOut*]

# LMK04832 IC programmed clock Skew
# The LMK04832 has the capability to delay one clock vs another in units of VCO cycles (312.5 ps @ 3.2 GHz)
# The following number represents the programmed TriggerOutClk skew in ps with respect to the FpgaDeviceClk
# A positive number means that TriggerOutClk is right-shifted in time with respect to the FpgaDeviceClk
# A negative number means that TriggerOutClk is left-shifted in time with respect to the FpgaDeviceClk
# The skew is set to 0 VCO cycles per the reported Vivado slack and measured setup/hold at the FF
set TrigOutClkToFpgaDeviceClkProgSkew 0.00

#  LMK04832 IC package Skew
# The TriggerOutClk to FpgaDeviceClk package skew was measured to be smaller than 100 ps
# The FpgaDeviceClk slightly lags the TriggerOutClk since the former is LVDS (slower edges)
# and the latter is LVPECL (faster edges).We are going to assume that the skew between these
# two clocks has a maximum of +/- 500 ps over PVT, which should be plenty generous.
set TrigOutClkFpgaDeviceClkPackageSkew 0.5

# FpgaDeviceClk/TriggerOutClk PCB routing Skew
# FpgaDeviceClk trace length = 1,023 mils on Sphinx
# TriggerOutClk trace length = 2,218 mils on Sphinx
# minimum delay = 120 ps/in * (1,023-2,218) = -144 ps;
# maximum delay = 180 ps/in * (1,023-2,218) = -215 ps;
set FpgaDevClkToTrigClkSphinxPcbSkewMin 0.14
set FpgaDevClkToTrigClkSphinxPcbSkewMax 0.22

# Trigger OUT PCB routing
# Sphinx trace length = 3,423 mils + connector delay (spec is ~25 ps)
# minimum delay = 120 ps/in * 3,423 = 411 ps ; assumes no propagation delay through connector
# maximum delay = 180 ps/in * 3,423 + 50 ps = 666 ps ; assumes 50 ps max connector delay
set outputTrigSphinxPcbDelayMin 0.41
set outputTrigSphinxPcbDelayMax 0.67

# Trigger OUT PECL Flop Setup/Hold
set NB4L52Setup 0.1
set NB4L52Hold 0.05

set FpgaToOutputTriggerMaxDelay  {$TrigOutClkFpgaDeviceClkPackageSkew -$TrigOutClkToFpgaDeviceClkProgSkew + $FpgaDevClkToTrigClkSphinxPcbSkewMax + $DataClk_Tpd_Max + $outputTrigSphinxPcbDelayMax + $NB4L52Setup}
set FpgaToOutputTriggerMinDelay  {0 - $TrigOutClkFpgaDeviceClkPackageSkew -$TrigOutClkToFpgaDeviceClkProgSkew + $FpgaDevClkToTrigClkSphinxPcbSkewMin + $DataClk_Tpd_Min + $outputTrigSphinxPcbDelayMin - $NB4L52Hold}

set_output_delay -clock [get_clocks -of_objects [get_ports DeviceClk_p]] -max [expr $FpgaToOutputTriggerMaxDelay] [get_ports aTriggerOut_p]
set_output_delay -clock [get_clocks -of_objects [get_ports DeviceClk_p]] -min [expr $FpgaToOutputTriggerMinDelay] [get_ports aTriggerOut_p]


#########################
## End add from file NI5774IoTiming.xdc
#########################


