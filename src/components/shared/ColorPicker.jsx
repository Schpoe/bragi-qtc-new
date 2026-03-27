import React from "react";

const PRESET_COLORS = [
  "#3b82f6", "#6366f1", "#8b5cf6", "#a855f7", "#ec4899",
  "#ef4444", "#f97316", "#f59e0b", "#84cc16", "#10b981",
  "#14b8a6", "#06b6d4", "#0ea5e9", "#64748b", "#6b7280",
];

/**
 * Reusable color picker with preset swatches, a native color wheel,
 * and an optional "Auto" button that clears the value.
 *
 * Props:
 *   value      – current hex string (e.g. "#3b82f6") or "" for no color
 *   onChange   – called with a hex string or "" (when cleared)
 *   showAuto   – show an "Auto" button that resets to "" (default false)
 */
export default function ColorPicker({ value = "", onChange, showAuto = false }) {
  return (
    <div className="space-y-2">
      <div className="flex flex-wrap gap-2 items-center">
        {PRESET_COLORS.map(c => (
          <button
            key={c}
            type="button"
            onClick={() => onChange(c)}
            className="w-7 h-7 rounded-full border-2 transition-all hover:scale-110"
            style={{
              backgroundColor: c,
              borderColor: value === c ? "#000" : "transparent",
              boxShadow: value === c ? "0 0 0 1px #fff inset" : "none",
            }}
            title={c}
          />
        ))}

        {/* Custom color wheel */}
        <label
          className="w-7 h-7 rounded-full border-2 border-dashed border-muted-foreground/40 flex items-center justify-center cursor-pointer hover:border-muted-foreground transition-colors overflow-hidden relative"
          title="Custom color"
        >
          <span className="text-xs text-muted-foreground leading-none select-none pointer-events-none">+</span>
          <input
            type="color"
            value={value || "#6b7280"}
            onChange={e => onChange(e.target.value)}
            className="absolute inset-0 opacity-0 cursor-pointer w-full h-full"
          />
        </label>

        {/* Auto / clear */}
        {showAuto && (
          <button
            type="button"
            onClick={() => onChange("")}
            className="text-xs text-muted-foreground hover:text-foreground px-2 h-7 rounded border border-dashed border-muted-foreground/40 transition-colors"
          >
            Auto
          </button>
        )}
      </div>

      {/* Current value preview */}
      {value && (
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <div className="w-4 h-4 rounded-full border border-black/10" style={{ backgroundColor: value }} />
          <span className="font-mono">{value}</span>
        </div>
      )}
    </div>
  );
}
